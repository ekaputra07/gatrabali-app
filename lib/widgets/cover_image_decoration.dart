import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoverImageDecoration extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback onTap;

  CoverImageDecoration(
      {this.url,
      this.height,
      this.width = 0,
      this.borderRadius = 0,
      this.onTap});

  @override
  Widget build(BuildContext ctx) {
    final imgUrl = url == null ? "" : url;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.grey,
          image: DecorationImage(
              image: CachedNetworkImageProvider(imgUrl), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
