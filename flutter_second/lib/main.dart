library painter;

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';

void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
  }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _onPanStart(BuildContext context, DragStartDetails start) {
    Offset pos=(context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    print(pos);
    widget.painterController._pathHistory.add(pos);
    widget.painterController._notifyListeners();
  }

  _onPanUpdate(BuildContext context, DragUpdateDetails update) {
    Offset pos=(context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    print(pos);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
  }

  _onPanEnd(BuildContext context, DragEndDetails end){
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }

  void add(Offset startPoint){
    if(!_inDrag) {
      _inDrag=true;
      Path path = new Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(new MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path=_paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag=false;
  }

  void draw(Canvas canvas,Size size){
    canvas.drawRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);
    for(MapEntry<Path,Paint> path in _paths){
      canvas.drawPath(path.key,path.value);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new GestureDetector(
          child: new Text(""),
          onHorizontalDragStart: (DragStartDetails start) =>
              _onPanStart(context, start),
          onHorizontalDragUpdate: (DragUpdateDetails update) =>
              __onPanUpdate(context, update),
        ),
      ),
    );
  }
}
