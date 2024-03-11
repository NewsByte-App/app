import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    this.height = 125,
    this.borderRadius = 20,
    required this.width,
    required this.imageUrl,
    this.padding,
    this.margin,
    this.child,
  }) : super(key: key);

  final double width;
  final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // Check if the image URL is for an SVG.
    bool isSvg = imageUrl.toLowerCase().endsWith('.svg');

    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        // For non-SVG images, apply the image as a decoration.
        image: isSvg
            ? null
            : DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
      ),
      // Use ClipRRect for SVG to clip it with rounded corners.
      child: isSvg
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: SvgPicture.network(
                imageUrl,
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
            )
          : child, // For non-SVG images, display the child widget if provided.
    );
  }
}
