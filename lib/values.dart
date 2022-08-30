import 'package:flutter/material.dart';
import 'package:servqual_analyzer/models.dart';

List<List<int>> rawDataH = [
  [0, 0, 7, 73, 20],
  [0, 0, 4, 71, 25],
  [0, 0, 11, 62, 27],
  [0, 3, 4, 66, 27],
  [0, 0, 7, 73, 20],
  [0, 0, 4, 77, 19],
  [0, 0, 11, 73, 16],
  [0, 0, 15, 62, 23],
  [0, 0, 19, 62, 19],
  [0, 0, 4, 85, 11],
  [0, 0, 19, 70, 11],
  [0, 0, 4, 76, 20],
  [0, 0, 5, 66, 30],
  [0, 4, 30, 51, 15],
  [0, 0, 4, 77, 19],
];

List<List<int>> rawDataK = [
  [0, 0, 0, 34, 66],
  [0, 0, 0, 46, 54],
  [0, 0, 0, 66, 34],
  [0, 0, 0, 53, 47],
  [0, 0, 0, 53, 47],
  [0, 0, 0, 50, 50],
  [0, 0, 4, 46, 50],
  [0, 0, 4, 30, 66],
  [0, 0, 0, 54, 46],
  [0, 0, 0, 61, 39],
  [0, 0, 0, 57, 43],
  [0, 0, 0, 47, 53],
  [0, 0, 0, 38, 62],
  [4, 0, 8, 46, 43],
  [0, 0, 0, 38, 62],
];
List<List<int>> rawStatementDim = [
  [1, 4, 5, 6],
  [7, 8, 9],
  [10, 12],
  [3],
  [2, 11, 13, 14, 15],
];

List<DimensionModel> dimensions = [
  DimensionModel(
    dimension: 'reliability',
    text: 'Keandalan',
  ),
  DimensionModel(
    dimension: 'responsiveness',
    text: 'Daya Tanggap',
  ),
  DimensionModel(
    dimension: 'assurance',
    text: 'Jaminan',
  ),
  DimensionModel(
    dimension: 'tangibles',
    text: 'Keadaan Fisik',
  ),
  DimensionModel(
    dimension: 'empathy',
    text: 'Empati',
  ),
];

List<String> likertNames = [
  'STS',
  'TS',
  'KS',
  'S',
  'SS',
];

enum FieldTypes {
  harapan,
  kenyataan,
}

TextEditingController dataCount = TextEditingController(text: '100');

List<ChartSampleModel> sumAndAverageVariables = [];

List<ChartSampleModel> chartGap5Varibles = [];

List<ChartSampleModel> chartSumNValueServqual = [];

List<ChartSampleModel> chartGap5Servqual = [];

List<StatementModel> statementsH = [
  ...List.generate(
    rawDataH.length,
    (i) => StatementModel(
      i: i + 1,
      dimension: dimensions[rawStatementDim.indexOf(
          rawStatementDim.where((element) => element.contains(i + 1)).first)],
      likerts: [
        ...List.generate(
          rawDataH[i].length,
          (j) => TextEditingController(text: '${rawDataH[i][j]}'),
        )
      ],
    ),
  )
];

List<StatementModel> statementsK = [
  ...List.generate(
    rawDataK.length,
    (i) => StatementModel(
      i: i + 1,
      dimension: dimensions[rawStatementDim.indexOf(
          rawStatementDim.where((element) => element.contains(i + 1)).first)],
      likerts: [
        ...List.generate(
          rawDataK[i].length,
          (j) => TextEditingController(text: '${rawDataK[i][j]}'),
        )
      ],
    ),
  )
];
