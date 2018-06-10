import 'package:flutter/material.dart';
import 'package:flutter_conversao_v2/categoria.dart';
import 'package:flutter_conversao_v2/unidade.dart';

final _backgroundColor = Colors.indigo[100];

class RotaCategoria extends StatefulWidget{
  const RotaCategoria();

  @override
  _RotaCategoriaState createState() => _RotaCategoriaState();

}

class _RotaCategoriaState extends State<RotaCategoria>{
  final _categorias = <Categoria>[];

  static const _categoriaNomes = <String>[
    'Comprimento',
    'Area',
    'Volume',
    'Massa',
    'Tempo',
    'Armazenamento digital',
    'Energia',
    'Moeda',
  ];

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

  @override
  void initState(){
    super.initState();
    for (var i = 0; i < _categoriaNomes.length; i++){
      _categorias.add(Categoria(
        nome: _categoriaNomes[i],
        cor: _baseCor[i],
        icone: Icons.camera,
        unidades: _trazerListaUnidade(_categoriaNomes[i]),
      ));
    }
  }

  Widget _categoriaDeWidgets(){
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _categorias[index],
      itemCount: _categorias.length,
    );
  }

  //Retorna uma lista de unidades.
  List<Unidade> _trazerListaUnidade(String categoriaNome){
    return List.generate(10, (int i){
      i += 1;
      return Unidade(
        nome: '$categoriaNome Unidade $i',
        conversao: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final listView = Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _categoriaDeWidgets(),
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Unidade de Conversão',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
      centerTitle: true,
      backgroundColor: _backgroundColor,
    );

    // TODO: implement build
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}