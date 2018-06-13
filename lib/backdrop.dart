import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_conversao_v2/categoria.dart';

const double _kFlingVelocidade = 2.0;

class _BackdropPanel extends StatelessWidget{
  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.titulo,
    this.child,
  }):super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget titulo;
  final Widget child;

  @override
  Widget build (BuildContext context){
    return Material (
      elevation: 2.0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead,
                child: titulo,
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(child: child,),
        ],
      ),
    );
  }

}

class _BackdropTitulo extends AnimatedWidget{
  final Widget frontTitulo;
  final Widget backTitulo;

  const _BackdropTitulo({
    Key key,
    Listenable listenable,
    this.frontTitulo,
    this.backTitulo,
  }): super (key: key, listenable: listenable);

  @override
  Widget build (BuildContext context){
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: Interval(0.5, 1.0),
            ).value,
            child: backTitulo,
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Interval(0.5, 1.0),
            ).value,
            child: frontTitulo,
          ),
        ],
      ),
    );
  }
}

class Backdrop extends StatefulWidget{
  final Categoria categoriaAtual;
  final Widget frontPanel;
  final Widget backPanel;
  final Widget frontTitulo;
  final Widget backTitulo;

  const Backdrop({
    @required this.categoriaAtual,
    @required this.frontPanel,
    @required this.backPanel,
    @required this.frontTitulo,
    @required this.backTitulo,
  })  : assert(categoriaAtual != null),
        assert(frontPanel != null),
        assert(backPanel != null),
        assert(frontTitulo != null),
        assert(backTitulo != null);

  @override
  _BackdropState createState() => _BackdropState();

}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
     _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);
    if (widget.categoriaAtual!= old.categoriaAtual) {
      setState(() {
        _controller.fling(
            velocity:
                _backdropPanelVisivel ? -_kFlingVelocidade : _kFlingVelocidade);
      });
    } else if (!_backdropPanelVisivel) {
      setState(() {
        _controller.fling(velocity: _kFlingVelocidade);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _backdropPanelVisivel {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisivel() {
    _controller.fling(
        velocity: _backdropPanelVisivel ? -_kFlingVelocidade : _kFlingVelocidade);
  }

  double get _backdropAltura {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _handleDragAtualizado(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.value -= details.primaryDelta / _backdropAltura;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropAltura;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(_kFlingVelocidade, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-_kFlingVelocidade, -flingVelocity));
    else
      _controller.fling(
          velocity:
              _controller.value < 0.5 ? -_kFlingVelocidade : _kFlingVelocidade);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTituloAltura = 48.0;
    final Size panelTamanho = constraints.biggest;
    final double panelTop = panelTamanho.height - panelTituloAltura;

    Animation<RelativeRect> panelAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelTamanho.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Container(
      key: _backdropKey,
      color: widget.categoriaAtual.cor,
      child: Stack(
        children: <Widget>[
          widget.backPanel,
          PositionedTransition(
            rect: panelAnimation,
            child: _BackdropPanel(
              onTap: _toggleBackdropPanelVisivel,
              onVerticalDragUpdate: _handleDragAtualizado,
              onVerticalDragEnd: _handleDragEnd,
              titulo: Text(widget.categoriaAtual.nome,
              ),
              child: widget.frontPanel,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.categoriaAtual.cor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: _toggleBackdropPanelVisivel,
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
          ),
        ),
        title: _BackdropTitulo(
          listenable: _controller.view,
          frontTitulo: widget.frontTitulo,
          backTitulo: widget.backTitulo,
        ),
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }


}