import 'package:flutter/material.dart';

class AppPadding extends StatelessWidget{
  const AppPadding({
    Key? key,
    required this.child,
    this.padding
  }) : super(key: key);
  
  final Widget child;
  final EdgeInsetsGeometry? padding;

  factory AppPadding.large({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    child: child
  );

  factory AppPadding.medium({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: child
  );

  factory AppPadding.small({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.all(10),
    child: child
  );
  factory AppPadding.object({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.all(20),
    child: child
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(10),
      child: child,
    );
  }
}