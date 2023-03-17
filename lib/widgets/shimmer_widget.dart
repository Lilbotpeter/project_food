import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  //ShimmerWidget Rectangular
  const ShimmerWidget.rectangular({
    this.width = double.infinity,
    required this.height,
    }) : this.shapeBorder = const RoundedRectangleBorder();

  //ShimmerWidget Circular
  const ShimmerWidget.circular({
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
    });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Color.fromARGB(255, 110, 109, 109),
    highlightColor: Colors.grey[300]!,
    child: Container(
        width: width,
        height: height,
        color: Colors.grey,
    ),
  );
}