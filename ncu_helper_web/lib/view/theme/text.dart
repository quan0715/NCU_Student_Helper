import 'package:flutter/material.dart';

class AppText{
  static TextStyle titleLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle titleMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle titleSmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.titleSmall!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle bodyLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle bodyMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle bodySmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle labelLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle labelMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle labelSmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle headLineLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle headLineMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle headLineSmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontFamily: "NotoSansTC",
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

}