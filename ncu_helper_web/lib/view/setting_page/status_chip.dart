import 'package:flutter/material.dart';

class StatusChip extends RawChip{
  StatusChip({
    Key? key,
    required String label,
    required Color color,
    // required Color textColor,
    // required IconData icon,
    // required VoidCallback onPressed,
  }) : super(
    key: key,
    label: Text(label),
    labelStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
    backgroundColor: color.withOpacity(0.05),
   // onPressed: onPressed,
    avatar: CircleAvatar(
        backgroundColor: color,
        radius: 5,
    ),
    visualDensity: VisualDensity.compact,
    side: BorderSide(color: color.withOpacity(0.2)),
  );
  
}