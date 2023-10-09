import 'package:flutter/material.dart';

class AppColor{
  static const Color onSuccessColor = Color(0xFF4CAF50);
  static const Color onWarningColor = Color(0xFFFFC107);
  static const Color onErrorColor = Color(0xFFF44336);
  static Color primary(BuildContext context) => Theme.of(context).colorScheme.primary; 
  static Color secondary(BuildContext context) => Theme.of(context).colorScheme.secondary;
  static Color tertiary(BuildContext context) => Theme.of(context).colorScheme.tertiary;
  static Color background(BuildContext context) => Theme.of(context).colorScheme.background;
  static Color primaryContainer(BuildContext context) => Theme.of(context).colorScheme.primaryContainer;
  static Color secondaryContainer(BuildContext context) => Theme.of(context).colorScheme.secondaryContainer;
  static Color tertiaryContainer(BuildContext context) => Theme.of(context).colorScheme.tertiaryContainer;
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color error(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color onPrimary(BuildContext context) => Theme.of(context).colorScheme.onPrimary;
  static Color onSecondary(BuildContext context) => Theme.of(context).colorScheme.onSecondary;
  static Color onTertiary(BuildContext context) => Theme.of(context).colorScheme.onTertiary;
  static Color onBackground(BuildContext context) => Theme.of(context).colorScheme.onBackground;
  static Color onSurface(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color onError(BuildContext context) => Theme.of(context).colorScheme.onError;
  static Color surfaceVariant(BuildContext context) => Theme.of(context).colorScheme.surfaceVariant;
  static Color onSurfaceVariant(BuildContext context) => Theme.of(context).colorScheme.onSurfaceVariant;
  static Color onPrimaryContainer(BuildContext context) => Theme.of(context).colorScheme.onPrimaryContainer;
  static Color onSecondaryContainer(BuildContext context) => Theme.of(context).colorScheme.onSecondaryContainer;
  static Color onTertiaryContainer(BuildContext context) => Theme.of(context).colorScheme.onTertiaryContainer;
  static Color brightness(BuildContext context) => Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black;
  static ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
  
}