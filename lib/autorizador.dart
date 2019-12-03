
class Autorizador {

  final String autorizador;
  final String autorizacao;
  final String retornoAutorizacao;
  final String inutilizacao;
  final String consultaProtocolo;
  final String statusServico;
  final String tempoMedio;
  final String consultaCadastro;
  final String recepcaoEvento;
  var isExpanded = false;

  Autorizador({
    this.autorizador,
    this.autorizacao,
    this.retornoAutorizacao,
    this.inutilizacao,
    this.consultaProtocolo,
    this.statusServico,
    this.tempoMedio,
    this.consultaCadastro,
    this.recepcaoEvento
  });

  factory Autorizador.fromMap(Map<String, dynamic> map) {
    return Autorizador(
      autorizador: map['autorizador'],
      autorizacao: map['autorizacao'],
      retornoAutorizacao: map['retorno_autorizacao'],
      inutilizacao: map['inutilizacao'],
      consultaProtocolo: map['consulta_protocolo'],
      statusServico: map['status_servico'],
      tempoMedio: map['tempo_medio'],
      consultaCadastro: map['consulta_cadastro'],
      recepcaoEvento: map['recepcao_evento']
    );
  }

}
