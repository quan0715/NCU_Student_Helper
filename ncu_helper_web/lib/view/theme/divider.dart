import 'package:flutter/material.dart';

class DashboardDivider extends StatelessWidget implements Divider{
  const DashboardDivider({
    Key? key,
    this.height,
    this.thickness,
    this.color,
    this.indent = 0,
    this.endIndent = 0
  }) : super(key: key);
  

  @override final double? height;
  @override final double? thickness;
  @override final Color? color;
  @override final double indent;
  @override final double endIndent;

  factory DashboardDivider.large({
    double? height = 10,
    double? thickness = 5,
    Color? color,
    double indent = 5,
    double endIndent = 5
  }) => DashboardDivider(
    height: height,
    thickness: thickness,
    color: color,
    indent: indent,
    endIndent: endIndent
  );

  factory DashboardDivider.medium({
    double? height = 5,
    double? thickness = 2,
    Color? color,
    double indent = 10,
    double endIndent = 10
  }) => DashboardDivider(
    height: height,
    thickness: thickness,
    color: color,
    indent: indent,
    endIndent: endIndent
  );

  factory DashboardDivider.small({
    double? height = 3,
    double? thickness = 1,
    Color? color,
    double indent = 20,
    double endIndent = 20
  }) => DashboardDivider(
    height: height,
    thickness: thickness,
    color: color,
    indent: indent,
    endIndent: endIndent
  );

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
  }
}