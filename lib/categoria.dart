import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
//import 'package:flutter_conversao/rota_categoria.dart';
import 'package:flutter_conversao_v2/unidade.dart';
import 'package:flutter_conversao_v2/rota_conversao.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight/2);



class Categoria extends StatelessWidget{
  final String nome;
  final ColorSwatch cor;
  final IconData icone;
  final List<Unidade> unidades;

  const Categoria({
    Key key,
    @required this.nome,
    @required this.cor,
    @required this.icone,
    @required this.unidades,
  }) : assert(nome != null),
        assert(cor != null),
        assert(icone != null),
        assert(unidades != null),
        super(key: key);

  //Navegação das rotas (Conversao Rota)
  void _navegarParaConversao(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              nome,
              style: Theme.of(context).textTheme.display1,
            ),
            centerTitle: true,
            backgroundColor: cor,
          ),
          body: RotaConversao(
            cor: cor,
            nome: nome,
            unidades: unidades,
          ),
          resizeToAvoidBottomPadding: false,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: Container(
          height: _rowHeight,
          child: InkWell(
            borderRadius: _borderRadius,
            highlightColor: cor['highlight'],
            splashColor: cor['splash'],
            onTap: () => _navegarParaConversao(context),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      icone,
                      size: 60.0,
                      color: Colors.white,
                    ),
                  ),
                  Center(
                    child: Text(
                      nome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ) ,
    );
  }
}