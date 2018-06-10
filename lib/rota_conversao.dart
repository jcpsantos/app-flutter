import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_conversao_v2/unidade.dart';

const _padding = EdgeInsets.all(16.0);

class RotaConversao extends StatefulWidget{
  //Dados da Categoria
  final String nome;//Nome da Categoria
  final Color cor;//Cor da cotegoria
  final List<Unidade> unidades; //Unidade por categoria

  const RotaConversao ({
    @required this.nome,
    @required this.cor,
    @required this.unidades
  }) : assert(nome != null),
        assert(cor != null),
        assert(unidades != null);

  @override
  _RotaConversaoState createState() => _RotaConversaoState();

}

class _RotaConversaoState extends State<RotaConversao>{
  Unidade _entValor;
  Unidade _saidaValor;
  double _inputValor;
  String _converterValor = '';
  List<DropdownMenuItem> _unidadeItemMenu; 
  bool _validacaoError = false;

  @override
  void initState(){
    super.initState();
    _criarDropdownMenuItem();
    _setDefaults();
  }

  // Cria uma nova lista de widgets
  void _criarDropdownMenuItem(){
    var newItem = <DropdownMenuItem>[];
    for (var unidade in widget.unidades){
      newItem.add(DropdownMenuItem(
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
          _unidadeItemMenu = newItem;
        });
  }

  // Define os valores padrão para 'entrada' e 'saída'
  void _setDefaults(){
    setState(() {
          _entValor = widget.unidades[0];
          _saidaValor = widget.unidades[1];
        });
  }

  String _formato(double conversion){
    var  outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')){
      var i = outputNum.length -1;
      while (outputNum[i] == 0){
        i -= 1;
      }
      outputNum = outputNum.substring(0, i+1);
    }
    if (outputNum.endsWith('.')){
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _atualizarConversao(){
    setState(() {
          _converterValor = _formato(_inputValor * (_saidaValor.conversao / _entValor.conversao));
        });
  }

  void _atualizarInputValor(String input){
    setState(() {
          if (input == null || input.isEmpty){
            _converterValor = '';
          }else{
            try{
              final inputDouble = double.parse(input);
              _validacaoError = false;
              _inputValor = inputDouble;
              _atualizarConversao();
            } on Exception catch (e){
              print('Error: $e');
              _validacaoError = true;
            }
          }
        });
  }

  Unidade _getUnidade(String unidadeNome){
    return widget.unidades.firstWhere(
      (Unidade unidade){
        return unidade.nome == unidadeNome;
      },
      orElse: null,
    );
  }

  void _atualizarFormulario (dynamic unidadeNome){
    setState(() {
          _entValor = _getUnidade(unidadeNome);
        });
        if (_inputValor != null){
          _atualizarConversao();
        }
  }

  Widget _criarDropdown (String valorAtual, ValueChanged<dynamic> onChanged){
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0
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
              items: _unidadeItemMenu,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context){
    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              errorText: _validacaoError ? 'Entrada de dados inválidos' : null,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _atualizarInputValor,
          ),
          _criarDropdown(_entValor.nome, _atualizarFormulario),
        ],
      ),
    );

    final arrows = RotatedBox(
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
        children: <Widget>[
          InputDecorator(
            child: Text(
              _converterValor,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
        ],
      )
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );    
  }

}  
    
