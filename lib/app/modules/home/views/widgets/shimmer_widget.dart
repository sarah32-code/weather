import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../config/theme/theme_extensions/shimmer_theme_data.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;

  const ShimmerWidget.rectangular({
    super.key, 
    this.width = double.infinity,
    required this.height,
    this.isCircle = false,
  });

  const ShimmerWidget.circular({
    super.key, 
    required this.width,
    required this.height,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final shimmerTheme = Theme.of(context).extension<ShimmerThemeData>()!;
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 138, 141, 130),
      highlightColor: shimmerTheme.highlightColor!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 138, 141, 130),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(6),
        ),
      ),
    );
  }
}