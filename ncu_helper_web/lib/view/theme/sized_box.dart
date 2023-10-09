import 'package:flutter/material.dart';

class AppSizedBox extends StatelessWidget{
  const AppSizedBox({
    super.key,
    this.width,
    this.height,
    this.child
  });
  final double? width;
  final double? height;
  final Widget? child;

  factory AppSizedBox.large({
    double? width = 15,
    double? height = 15,
    Widget? child,
  }) => AppSizedBox(
    width: width,
    height: height,
    child: child
  );

  factory AppSizedBox.medium({
    double? width = 10,
    double? height = 10,
    Widget? child
  }) => AppSizedBox(
    width: width,
    height: height,
    child: child
  );

  factory AppSizedBox.small({
    double? width = 5,
    double? height = 5,
    Widget? child
  }) => AppSizedBox(
    width: width,
    height: height,
    child: child
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}