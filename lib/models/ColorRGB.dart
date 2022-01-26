import 'dart:math';

import 'package:flutter/material.dart';

class ColorRGB {
  final int r, g, b;

  ColorRGB(this.r, this.g, this.b);

  ColorRGB blend(ColorRGB to, double factor) {
    int r = this.r + ((to.r - this.r) * factor).toInt();
    int g = this.g + ((to.g - this.g) * factor).toInt();
    int b = this.b + ((to.b - this.b) * factor).toInt();
    return ColorRGB(r, g, b);
  }

  ColorRGB copy() {
    return ColorRGB(r, g, b);
  }

  Color get() {
    return Color.fromARGB(255, r, g, b);
  }

  @override
  bool operator ==(Object other) {
    if (other is ColorRGB) {
      return (this.r == other.r && this.g == other.g && this.b == other.b);
    }
    return null;
  }

  @override
  String toString() {
    return "R:${this.r} G:${this.g} B:${this.b}";
  }
}

ColorRGB getColor() {
  final rnd = Random();

  int r = rnd.nextInt(255);
  int g = rnd.nextInt(255);
  int b = rnd.nextInt(255);
  return ColorRGB(r, g, b);
}
