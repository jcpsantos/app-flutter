import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
//import 'package:flutter_conversao/rota_categoria.dart';
import 'package:flutter_conversao_v2/unidade.dart';
import 'package:flutter_conversao_v2/rota_conversao.dart';


class Categoria{
  final String nome;
  final ColorSwatch cor;
  final IconData icone;
  final List<Unidade> unidades;

  const Categoria({
    @required this.nome,
    @required this.cor,
    @required this.icone,
    @required this.unidades,
  }) : assert(nome != null),
        assert(cor != null),
        assert(icone != null),
        assert(unidades != null);
       
}