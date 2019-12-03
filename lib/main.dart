import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:status_nfe/autorizador.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Status NF-e',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MainHomePage(title: 'Status NF-e'),
    );
  }
}

// MainHomePage
class MainHomePage extends StatefulWidget {
  MainHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  Future<List<Autorizador>> _listFuture;

  @override
  void initState() {
    super.initState();

    _listFuture = _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            return Center(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Ocorreu um erro ao consultar. Por favor, tente novamente mais tarde !",
                textAlign: TextAlign.center,
              ),
            ));
          }

          List<Autorizador> autorizadores = snapshot.data;

          return SingleChildScrollView(
              child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                autorizadores[index].isExpanded = !isExpanded;
              });
            },
            children: autorizadores
                .map((i) => ExpansionPanel(
                    headerBuilder: (builder, isExpanded) {
                      return ListTile(
                        title: Text(i.autorizador),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          // Autorização
                          _getStatusTile(i.autorizacao, "Autorização"),
                          _getStatusTile(i.retornoAutorizacao, "Retorno Autorização"),
                          _getStatusTile(i.inutilizacao, "Inutilização"),
                          _getStatusTile(i.consultaProtocolo, "Consulta Protocolo"),
                          _getStatusTile(i.statusServico, "Status Serviço"),
                          _getStatusTile(i.consultaCadastro, "Consulta Cadastro"),
                          _getStatusTile(i.recepcaoEvento, "Recepção Evento"),
                        ],
                      ),
                    ),
                    isExpanded: i.isExpanded))
                .toList(),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => setState(() => {_listFuture = _fetch()}),
      ),
    );
  }

  Future<List<Autorizador>> _fetch() async {
    final response =
        await http.get('https://masterdeveloper-status-nfe.appspot.com/');
    final json = jsonDecode(response.body);
    final List<dynamic> autorizadores = json["autorizadores"];

    return List.generate(
        autorizadores.length, (i) => Autorizador.fromMap(autorizadores[i]));
  }

  Color _getColor(String status) {
    switch (status) {
      case "verde":
        return Colors.green.shade500;
      case "amarela":
        return Colors.yellow.shade500;
      case "vermelho":
        return Colors.red.shade500;
      default:
        return Colors.transparent;
    }
  }

  Widget _getStatusTile(String status, String label) => ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: _getColor(status),
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        title: Text(label),
        dense: true,
      );
}
