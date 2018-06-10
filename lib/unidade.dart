import 'package:meta/meta.dart';

//Informação sobre a unidade
class Unidade{
  final String nome;
  final double conversao;

  const Unidade({
    @required this.nome,
    @required this.conversao,
  }) : assert(nome != null),
        assert(conversao != null);

//Unidade--Objeto JSON
  Unidade.fromJson(Map jsonMap)
      : nome = jsonMap['nome'],
        conversao = jsonMap['conversao'].toDouble(),
        assert(nome != null),
        assert(conversao != null);
}


