import 'package:flutter/material.dart';
import 'package:ncu_helper/view/theme/theme.dart';

class DataDisplayCard extends StatelessWidget {
  const DataDisplayCard({
    Key? key,
    required this.title,
    required this.child,
    this.elevation = 0.0,
    this.direction = "vertical",
  }) : super(key: key);

  final String title;
  final Widget child;
  final double elevation;
  final String direction;
  
  factory DataDisplayCard.horizontal({
    Key? key,
    required String title,
    required Widget child,
    double elevation = 0.0,
  }) {
    return DataDisplayCard(
      key: key,
      title: title,
      elevation: elevation,
      direction: "horizontal",
      child: child,
    );
  }

  factory DataDisplayCard.vertical({
    Key? key,
    required String title,
    required Widget child,
    double elevation = 0.0,
  }) {
    return DataDisplayCard(
      key: key,
      title: title,
      elevation: elevation,
      direction: "vertical",
      child: child,
    );
  }

  Widget _getTitleWidget(BuildContext context){
    return Text(
      title,
      style: AppText.labelLarge(context).copyWith(
        fontWeight: FontWeight.bold,
        color: AppColor.primary(context),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: direction == "horizontal" 
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getTitleWidget(context),
            const Spacer(),
            child,
          ])
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitleWidget(context),
            const SizedBox(width: 10,),
            child,
          ],
        ),
      ),
    );
  }
}