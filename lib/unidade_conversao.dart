import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_conversao_v2/unidade.dart';
import 'package:flutter_conversao_v2/categoria.dart';
import 'dart:async';
import 'package:flutter_conversao_v2/api.dart';

const _padding = EdgeInsets.all(16.0);

class UnidadeConversao extends StatefulWidget{
  final Categoria categoria;

  const UnidadeConversao({
    @required this.categoria
  }) : assert(categoria != null);

  @override
  _UnidadeConversaoState createState() => _UnidadeConversaoState();

}

class _UnidadeConversaoState extends State<UnidadeConversao>{
  Unidade _entValor;
  Unidade _saidaValor;
  double _inputValor;
  String _converterValor = '';
  List<DropdownMenuItem> _unidadeMenuItems;
  bool _validacaoComError = false;
  final _inputKey = GlobalKey(debugLabel: 'inputTexto');
  bool _mostrarErrorUI = false;

  @override
  void initState() {
    super.initState();
    _criarDropdownMenuItems();
    _setDefaults();
  }

  @override
  void didUpdateWidget(UnidadeConversao old) {
    super.didUpdateWidget(old);
    if (old.categoria != widget.categoria) {
      _criarDropdownMenuItems();
      _setDefaults();
    }
  }

  void _criarDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unidade in widget.categoria.unidades) {
      newItems.add(DropdownMenuItem(
        value: unidade.nome,
        child: Container(
          child: Text(
            unidade.nome,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _unidadeMenuItems = newItems;
    });
  }

  void _setDefaults() {
    setState(() {
      _entValor = widget.categoria.unidades[0];
      _saidaValor = widget.categoria.unidades[1];
    });
    if (_inputValor != null) {
      _atualizarConversao();
    }
  }

  String _formato(double conversao) {
    var outputNum = conversao.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

 Future<void>  _atualizarConversao() async {
    if (widget.categoria.nome == apiCategoria['nome']){
      final api = Api();
      final conversao =  await api.convert(apiCategoria['rota'], _inputValor.toString(), _entValor.nome, _saidaValor.nome);
      if (conversao == null){
        _mostrarErrorUI = true;
      }else{
        setState(() {
              _converterValor = _formato(conversao);
            });
      }
    }else{
      setState(() {
              _converterValor=_formato(_inputValor * (_saidaValor.conversao / _entValor.conversao));
            });
    }
  }

  void _atualizarInputValor(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _converterValor = '';
      } else {
        try {
          final inputDouble = double.parse(input);
          _validacaoComError = false;
          _inputValor = inputDouble;
          _atualizarConversao();
        } on Exception catch (e) {
          print('Error: $e');
          _validacaoComError = true;
        }
      }
    });
  }

  Unidade _getUnidade(String unidadeNome) {
    return widget.categoria.unidades.firstWhere(
      (Unidade unidade) {
        return unidade.nome == unidadeNome;
      },
      orElse: null,
    );
  }

  void _atualizarEntConversao(dynamic unidadeNome) {
    setState(() {
      _entValor = _getUnidade(unidadeNome);
    });
    if (_inputValor != null) {
      _atualizarConversao();
    }
  }

  void _atualizarSaidaConversao(dynamic unidadeNome) {
    setState(() {
      _saidaValor = _getUnidade(unidadeNome);
    });
    if (_inputValor != null) {
      _atualizarConversao();
    }
  }

  Widget _criarDropdown(String valorAtual, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[50],
            ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: valorAtual,
              items: _unidadeMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

   @override
  Widget build(BuildContext context) {
    if (widget.categoria.unidades == null ||
    (widget.categoria.nome == apiCategoria['nome'] && _mostrarErrorUI)){
      return SingleChildScrollView(
        child: Container(
          margin: _padding,
          padding: _padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: widget.categoria.cor['error'],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 180.0,
                color: Colors.white,
              ),
              Text(
                "Oh não! Não podemos conectar agora! Que Chato!!!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: _inputKey,
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              errorText: _validacaoComError ? 'Número inválido, por favor conferir os dados' : null,
              labelText: 'Entrada',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _atualizarInputValor,
          ),
          _criarDropdown(_entValor.nome, _atualizarEntConversao),
        ],
      ),
    );
    
    final seta = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _converterValor,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Saída',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _criarDropdown(_saidaValor.nome, _atualizarSaidaConversao),
        ],
      ),
    );

    final converter = Column(
      children: [
        input,
        seta,
        output,
      ],
    );

     return Padding(
      padding: _padding,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation){
          if (orientation == Orientation.portrait){
            return converter;
          }else{
            return Center(
              child: Container(
                width: 450.0,
                child: converter,
              ),
            );
          }
        },
      ),
    );
  }

}