import 'package:flutter/material.dart';

class DimensionModel {
  final String dimension;
  final String text;

  DimensionModel({required this.dimension, required this.text});
}

class StatementModel {
  final int i;
  DimensionModel dimension;

  List<TextEditingController> likerts;

  double? sum;
  double? average;

  StatementModel({
    required this.i,
    required this.dimension,
    required this.likerts,
    this.sum,
    this.average,
  });
}

///Chart sample data
class ChartSampleModel {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleModel({
    this.x,
    this.y,
    this.y1,
    this.y2,
    this.y3,
    this.y4,
    this.y5,
    this.y6,
    this.color,
    this.text,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds y[i] value of the datapoint
  final num? y1;
  final num? y2;
  final num? y3;
  final num? y4;
  final num? y5;
  final num? y6;

  /// Holds  color of the datapoint
  final Color? color;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;
}
