import 'package:flutter/material.dart';

class CharThumbnail extends StatelessWidget {
  final String char;
  final double width;
  final double height;
  final double fontSize;
  final Color color;

  CharThumbnail(
      {@required this.char,
      this.color = Colors.green,
      this.width = 50.0,
      this.height = 50.0,
      this.fontSize = 28.0});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      color: color,
      alignment: Alignment.center,
      width: width,
      height: height,
      child: Text(char.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w300)),
    );
  }
}
