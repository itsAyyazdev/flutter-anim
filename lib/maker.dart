import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AnimationMaker {
  @override
  Path paint(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.07, size.height * 0.08);
    path.quadraticBezierTo(size.width * 0.07, size.height * 0.04,
        size.width * 0.13, size.height * 0.04);
    path.cubicTo(size.width * 0.32, size.height * 0.04, size.width * 0.68,
        size.height * 0.04, size.width * 0.87, size.height * 0.04);
    path.quadraticBezierTo(size.width * 0.93, size.height * 0.04,
        size.width * 0.93, size.height * 0.08);
    path.quadraticBezierTo(size.width * 0.93, size.height * 0.44,
        size.width * 0.93, size.height * 0.56);
    path.cubicTo(size.width * 0.93, size.height * 0.72, size.width * 0.61,
        size.height * 0.81, size.width * 0.53, size.height * 0.84);
    path.quadraticBezierTo(size.width * 0.49, size.height * 0.85,
        size.width * 0.46, size.height * 0.84);
    path.quadraticBezierTo(size.width * 0.07, size.height * 0.72,
        size.width * 0.07, size.height * 0.56);
    path.quadraticBezierTo(size.width * 0.07, size.height * 0.44,
        size.width * 0.07, size.height * 0.08);
    path.close();
    return path;
  }

  //Here starts the Metatron-------------------------------
  final double r = 2;
  late List<Path> paths;
  Grid g = Grid();

  Path circle(Offset offset) {
    return Path()..addOval(Rect.fromCircle(center: offset, radius: r));
  }

  Path rect(Offset offset) {
    return Path()..addRect(Rect.fromCircle(center: offset, radius: r / 4));
  }

  Path line(Offset a, Offset b) {
    return Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy);
  }

  Path center(Offset a, Offset b) {
    var cp = Offset.lerp(a, b, 0.5);
    return line(cp!, g[2][2]);
  }

  Path out(Offset a) {
    var cp = Offset.lerp(g[2][2], a,
        3 / 4); //TODO make it so only depends on r - no hardcoded values
    return line(g[2][2], cp!);
  }

  Paint colorize(int index) {
    //Main colors
    Color primaryColor = Colors.blueAccent;
    Color secondaryColor = Colors.orangeAccent;
    Color doodleColor = Colors.black;

    //Shaders
    var t = 5 * r;
    var grad = ui.Gradient.radial(g[2][2], t, [doodleColor, secondaryColor],
        [3.0 * r / t, 4 * r / t], TileMode.decal);

    //Gray circles
    if (index <= 3) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..color = doodleColor
        ..strokeWidth = 0.2
        ..strokeCap = StrokeCap.round;
    }

    //Gray triangles
    if (index >= 3) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..shader = grad
        ..color = Colors.transparent
        ..strokeWidth = 0.2
        ..strokeCap = StrokeCap.round;
    }

    //Default
    return Paint()
      ..style = PaintingStyle.stroke
      ..color = primaryColor
      ..strokeWidth = 0.24
      ..strokeCap = StrokeCap.round;
  }

  List<Path> createMetatron() {
    var paths = <Path>[];

    paths
      ..add(circle(g[1][2]))
      ..add(circle(g[2][2]))
      ..add(circle(g[3][2]))
      ..add(circle(g[4][2]));

    paths.add(line(g[0][3], g[2][4]));
    paths..add(out(g[6][0]));

    return paths;
  }
}

//Wraps a grid function in a class so I can use the 2D array syntax, but with doubles
class Grid {
  Roww operator [](num i) => Roww(i.toDouble()); // get
}

class Roww {
  const Roww(this.row);
  final double row;
  Offset operator [](num col) => _g(row, col.toDouble());

  //Defines the grid
  Offset _g(double x, double y) {
    var r = 1.7;
    var d = r * 2;
    return Offset.zero.translate(x * d, y * d);
  }
}
