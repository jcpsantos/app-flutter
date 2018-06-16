import 'package:flutter/material.dart';
import 'package:flutter_conversao_v2/categoria.dart';
import 'package:flutter_conversao_v2/unidade.dart';
import 'package:flutter_conversao_v2/backdrop.dart';
import 'package:flutter_conversao_v2/categoria_home.dart';
import 'package:flutter_conversao_v2/unidade_conversao.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_conversao_v2/api.dart';


class RotaCategoria extends StatefulWidget{
  const RotaCategoria();

  @override
  _RotaCategoriaState createState() => _RotaCategoriaState();

}

class _RotaCategoriaState extends State<RotaCategoria>{
  Categoria _categoriaDefault;
  Categoria _categoriaAtual;
  final _categorias = <Categoria>[];

  static const _baseCor = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8,{
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

 static const _icones = <String>[
    'assets/icone/comprimento.png',
    'assets/icone/area.png',
    'assets/icone/volume.png',
    'assets/icone/massa.png',
    'assets/icone/hora.png',
    'assets/icone/digital.png',
    'assets/icone/energia.png',
    'assets/icone/moeda.png',
  ];
 

  @override
  Future<void> didChangeDependencies() async{
    super.didChangeDependencies();
    if (_categorias.isEmpty){
      await _retrieveLocalCategorias();
      await _retrieveApiCategoria();
    }
  }

  Future<void> _retrieveLocalCategorias() async {
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/unidades_regular.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Dados recuperados da API não é um Map');
    }
    var categoriaIndex = 0;
    data.keys.forEach((key) {
      final List<Unidade> unidades =
          data[key].map<Unidade>((dynamic data) => Unidade.fromJson(data)).toList();

      var categoria = Categoria(
        nome: key,
        unidades: unidades,
        cor: _baseCor[categoriaIndex],
        icone: _icones[categoriaIndex],
      );
      setState(() {
        if (categoriaIndex == 0) {
          _categoriaDefault = categoria;
        }
        _categorias.add(categoria);
      });
      categoriaIndex += 1;
    });
  }

  Future<void> _retrieveApiCategoria() async{
    setState(() {
          _categorias.add(Categoria(
            nome: apiCategoria['nome'],
            unidades: [],
            cor: _baseCor.last,
            icone: _icones.last,
          ));
        });

        final api = Api();
        final jsonUnidades = await api.getUnidades(apiCategoria['rota']);
        if (jsonUnidades != null){
          final unidades = <Unidade>[];
          for (var unidade in jsonUnidades){
            unidades.add(Unidade.fromJson(unidade));
          }
          setState(() {
                      _categorias.removeLast();
                      _categorias.add(Categoria(
                        nome: apiCategoria['nome'],
                        unidades: unidades,
                        cor: _baseCor.last,
                        icone: _icones.last,
                      ));
                    });
        }
  }

  void _onCategoriaTap(Categoria categoria) {
    setState(() {
      _categoriaAtual = categoria;
    });
  }

  Widget _categoriaDeWidgets(Orientation deviceOrientacao){
    if (deviceOrientacao == Orientation.portrait){
      return ListView.builder(
      itemBuilder: (BuildContext context, int index){
        return CategoriaHome(
          categoria: _categorias[index],
          onTap: _onCategoriaTap,
        );
      },
      itemCount: _categorias.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categorias.map((Categoria c) {
          return CategoriaHome(
            categoria: c,
            onTap: _onCategoriaTap,
          );
        }).toList(),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
     if (_categorias.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _categoriaDeWidgets(MediaQuery.of(context).orientation),
    );

    return Backdrop(
      categoriaAtual:
      _categoriaAtual == null ? _categoriaDefault : _categoriaAtual,
      frontPanel: _categoriaAtual == null
      ? UnidadeConversao(categoria: _categoriaDefault)
      : UnidadeConversao(categoria: _categoriaAtual),
      backPanel: listView,
      frontTitulo: Text ('Unidade Conversão'),
      backTitulo: Text ('Selecione a Categoria'),
    );
  }

}