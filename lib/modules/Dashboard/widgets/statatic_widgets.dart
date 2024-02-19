import 'package:flutter/material.dart';

Container verticalColorMargin(Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      ),
    ),
    height: double.infinity,
    width: 8,
  );
}
