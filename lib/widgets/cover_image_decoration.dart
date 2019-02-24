import 'package:flutter/material.dart';

class CoverImageDecoration extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final VoidCallback onTap;

  CoverImageDecoration({this.url, this.height, this.width = 0, this.onTap});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
