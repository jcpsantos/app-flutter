import 'package:flutter/material.dart';
//import 'package:flutter_conversao/categoria.dart';
import 'package:flutter_conversao_v2/rota_categoria.dart';

//A função que é chamada quando main.dart é executado.
void main(){
  runApp(ConverterApp());
}

class ConverterApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unidade de Conversão',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.grey[600],
        ),
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: RotaCategoria(),
    );
  }
}