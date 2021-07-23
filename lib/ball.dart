import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double diam = 50;
 final Color color;
 Ball(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: diam,
      height: diam,
      decoration: BoxDecoration(
        shape:BoxShape.circle,
        color: this.color
      ),
    );
  }
}