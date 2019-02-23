import 'package:flutter/material.dart';

class CoverImageDecoration extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  CoverImageDecoration({this.url, this.height, this.width = 0});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
      ),
    );
  }
}