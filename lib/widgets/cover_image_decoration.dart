import 'package:flutter/material.dart';

class CoverImageDecoration extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final VoidCallback onTap;

  CoverImageDecoration({this.url, this.height, this.width = 0, this.onTap});

  @override
  Widget build(BuildContext ctx) {
    final imgUrl = url == null ? "" : url;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
