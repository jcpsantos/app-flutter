import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_conversao_v2/categoria.dart';

const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight/2);

class CategoriaHome extends StatelessWidget{
  final Categoria categoria;
  final ValueChanged<Categoria> onTap;

  const CategoriaHome({
    Key key,
    @required this.categoria,
    @required this.onTap,
  }) : assert(categoria != null),
       assert(onTap != null),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: categoria.cor['highlight'],
          splashColor: categoria.cor['splash'],
          onTap: () => onTap(categoria),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset(categoria.icone),
                  ),
                Center(
                  child: Text(
                    categoria.nome,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }     
}


