import 'package:flutter/material.dart';

class ReponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  const ReponsiveLayout({Key? key,required this.mobileScreenLayout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return mobileScreenLayout;
      },
    );
  }
}