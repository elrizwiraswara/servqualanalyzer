import 'package:flutter/material.dart';
import 'package:servqual_analyzer/models.dart';
import 'package:servqual_analyzer/values.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_charts/charts.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  void initState() {
    analyze();
    super.initState();
  }

  Future<void> analyze() async {
    sumAndAverageVariables.clear();
    chartGap5Varibles.clear();
    chartSumNValueServqual.clear();
    chartGap5Servqual.clear();

    for (StatementModel statement in statementsH) {
      int sum = 0;
      for (int i = 0; i < statement.likerts.length; i++) {
        sum += int.parse(statement.likerts[i].text) * (i + 1);
      }
      statement.sum = sum.toDouble();
      statement.average = sum / int.parse(dataCount.text);
    }

    for (StatementModel statement in statementsK) {
      int sum = 0;
      for (int i = 0; i < statement.likerts.length; i++) {
        sum += int.parse(statement.likerts[i].text) * (i + 1);
      }
      statement.sum = sum.toDouble();
      statement.average = sum / int.parse(dataCount.text);
    }

    for (int i = 0; i < statementsH.length; i++) {
      sumAndAverageVariables.add(
        ChartSampleModel(
          x: 'V${i + 1}',
          y: statementsH[i].sum,
          y1: statementsH[i].average,
          y2: statementsK[i].sum,
          y3: statementsK[i].average,
        ),
      );
    }

    for (int i = 0; i < statementsH.length; i++) {
      double gapVi =
          (statementsH[i].average ?? 0) - (statementsK[i].average ?? 0);
      chartGap5Varibles.add(
        ChartSampleModel(
          x: 'V${i + 1}',
          y: gapVi,
        ),
      );
    }

    for (DimensionModel dimension in dimensions) {
      int nH = 0;
      int nK = 0;
      double sumH = 0;
      double sumK = 0;

      for (int i = 0; i < statementsH.length; i++) {
        if (statementsH[i].dimension == dimension) {
          nH += 1;
          sumH += statementsH[i].average ?? 0;
        }
        if (statementsK[i].dimension == dimension) {
          nK += 1;
          sumK += statementsK[i].average ?? 0;
        }
      }

      double servqualValH = sumH / nH;
      double servqualValK = sumK / nK;

      chartSumNValueServqual.add(
        ChartSampleModel(
          x: dimension.text,
          y: sumH,
          y1: servqualValH,
          y2: sumK,
          y3: servqualValK,
        ),
      );

      chartGap5Servqual.add(
        ChartSampleModel(
          x: dimension.text,
          y: servqualValK - servqualValH,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Analisis Data',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width < 1000
              ? 1000
              : MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                averageChart(),
                averageTable(),
                const Divider(),
                gap5VariablesChart(),
                gap5VariablesTable(),
                const Divider(),
                averageChartServqual(),
                averageTableServqual(),
                const Divider(),
                gap5VariablesChartServqual(),
                gap5VariablesTableServqual(),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget averageChart() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 8, top: 22),
          child: Text(
            'Rata-Rata Jawaban Responden\n(n = ${dataCount.text})',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: sumAndAverageVariables
                .reduce(
                    (value, element) => value.y! > element.y! ? value : element)
                .y!
                .toDouble(),
            plotOffset: 6,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          series: <ChartSeries<ChartSampleModel, String>>[
            ColumnSeries<ChartSampleModel, String>(
              dataSource: sumAndAverageVariables,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y2,
              name: 'Nilai Harapan',
              color: Colors.red.shade200,
            ),
            ColumnSeries<ChartSampleModel, String>(
              dataSource: sumAndAverageVariables,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y3,
              name: 'Rata-Rata Harapan',
              color: Colors.red.shade100,
            ),
            ColumnSeries<ChartSampleModel, String>(
              dataSource: sumAndAverageVariables,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y,
              name: 'Nilai Kenyataan',
              color: Colors.green.shade200,
            ),
            ColumnSeries<ChartSampleModel, String>(
              dataSource: sumAndAverageVariables,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y1,
              name: 'Rata-Rata Kenyataan',
              color: Colors.green.shade100,
            ),
          ],
        ),
      ],
    );
  }

  Widget gap5VariablesChart() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 18, bottom: 8, top: 22),
          child: Text(
            'Nilai Gap 5',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(
            plotOffset: 7,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            minimum: -(chartGap5Varibles.isNotEmpty
                ? chartGap5Varibles
                    .reduce((value, element) =>
                        value.y! > element.y! ? element : value)
                    .y!
                    .toDouble()
                : 4.0),
            maximum: chartGap5Varibles.isNotEmpty
                ? chartGap5Varibles
                    .reduce((value, element) =>
                        value.y! > element.y! ? element : value)
                    .y!
                    .toDouble()
                : 4.0,
            plotOffset: 6,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<ChartSampleModel, String>>[
            ColumnSeries<ChartSampleModel, String>(
              dataSource: chartGap5Varibles,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y,
              name: 'Nilai Gap 5',
              color: Colors.teal.shade300,
            ),
          ],
        ),
      ],
    );
  }

  Widget averageTable() {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Table(
            border: TableBorder.all(
              width: 1,
              color: Colors.black26,
            ),
            columnWidths: const {
              0: FlexColumnWidth(0.6),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  textColumn(
                    'VAR',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    '∑Hi',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    '∑Hi/n',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    '∑Ki',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    '∑Ki/n',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                ],
              ),
              if (statementsH.isNotEmpty)
                ...List.generate(
                  statementsH.length,
                  (i) => TableRow(
                    children: [
                      textColumn(
                        'V${i + 1}',
                        textAlign: TextAlign.center,
                      ),
                      textColumn(
                        '${statementsK[i].sum}',
                        textAlign: TextAlign.center,
                      ),
                      textColumn(
                        '${statementsK[i].average}',
                        textAlign: TextAlign.center,
                      ),
                      textColumn(
                        '${statementsH[i].sum}',
                        textAlign: TextAlign.center,
                      ),
                      textColumn(
                        '${statementsH[i].average}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                TableRow(
                  children: [
                    ...List.generate(
                      5,
                      (i) => textColumn(
                        'No Data',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget gap5VariablesTable() {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Table(
            border: TableBorder.all(
              width: 1,
              color: Colors.black26,
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  ...List.generate(
                    chartGap5Varibles.length,
                    (i) => textColumn(
                      '${chartGap5Varibles[i].x}',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w900,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.10),
                      ),
                    ),
                  )
                ],
              ),
              TableRow(
                children: [
                  ...List.generate(
                    chartGap5Varibles.length,
                    (i) => textColumn(
                      chartGap5Varibles[i].y!.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget averageChartServqual() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 18, bottom: 8, top: 22),
          child: Text(
            'Rata-Rata Gap 5 Servqual',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(
            plotOffset: 7,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: chartSumNValueServqual
                .reduce(
                    (value, element) => value.y! > element.y! ? value : element)
                .y!
                .toDouble(),
            plotOffset: 6,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<ChartSampleModel, String>>[
            ColumnSeries<ChartSampleModel, String>(
              dataSource: chartSumNValueServqual,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y2,
              name: 'Jumlah Rata-Rata Harapan',
              color: Colors.red.shade200,
            ),
            ColumnSeries<ChartSampleModel, String>(
              dataSource: chartSumNValueServqual,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y3,
              name: 'Nilai Harapan Pelayanan',
              color: Colors.red.shade100,
            ),
            ColumnSeries<ChartSampleModel, String>(
              dataSource: chartSumNValueServqual,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y,
              name: 'Jumlah Rata-Rata Kenyataan',
              color: Colors.green.shade200,
            ),
            ColumnSeries<ChartSampleModel, String>(
              dataSource: chartSumNValueServqual,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y1,
              name: 'Nilai Kenyataan Pelayanan',
              color: Colors.green.shade100,
            ),
          ],
        ),
      ],
    );
  }

  Widget averageTableServqual() {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Table(
            border: TableBorder.all(
              width: 1,
              color: Colors.black26,
            ),
            columnWidths: const {
              0: FlexColumnWidth(0.6),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  textColumn(
                    'Dimensi Pernyataan',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    'Atribut Pernyataan',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    'Jumlah Rata-Rata Harapan',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    'Jumlah Rata-Rata Kenyataan',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    'Nilai Harapan Pelayanan',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  textColumn(
                    'Nilai Kenyataan Pelayanan',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                ],
              ),
              ...List.generate(
                dimensions.length,
                (i) => TableRow(
                  children: [
                    textColumn(
                      dimensions[i].text,
                      textAlign: TextAlign.center,
                    ),
                    textColumn(
                      statementsH
                          .where(
                              (element) => element.dimension == dimensions[i])
                          .map((e) => e.i)
                          .toString(),
                      textAlign: TextAlign.center,
                    ),
                    textColumn(
                      chartSumNValueServqual[i].y2?.toStringAsFixed(2) ?? '0',
                      textAlign: TextAlign.center,
                    ),
                    textColumn(
                      chartSumNValueServqual[i].y?.toStringAsFixed(2) ?? '0',
                      textAlign: TextAlign.center,
                    ),
                    textColumn(
                      chartSumNValueServqual[i].y3?.toStringAsFixed(2) ?? '0',
                      textAlign: TextAlign.center,
                    ),
                    textColumn(
                      chartSumNValueServqual[i].y1?.toStringAsFixed(2) ?? '0',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget gap5VariablesChartServqual() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 18, bottom: 8, top: 22),
          child: Text(
            'Nilai Gap 5 Berdasarkan 5 Dimensi Servqual',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(
            plotOffset: 7,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            minimum: -(chartGap5Servqual.isNotEmpty
                ? chartGap5Servqual
                    .reduce((value, element) =>
                        (value.y ?? 0) > (element.y ?? 0) ? value : element)
                    .y!
                    .toDouble()
                : 4.0),
            maximum: chartGap5Servqual.isNotEmpty
                ? chartGap5Servqual
                    .reduce((value, element) =>
                        (value.y ?? 0) > (element.y ?? 0) ? value : element)
                    .y!
                    .toDouble()
                : 4.0,
            plotOffset: 6,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            // axisLine: const AxisLine(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<ChartSampleModel, String>>[
            ColumnSeries<ChartSampleModel, String>(
              dataSource: chartGap5Servqual,
              xValueMapper: (ChartSampleModel data, _) => data.x,
              yValueMapper: (ChartSampleModel data, _) => data.y,
              name: 'Nilai Gap 5 Berdsarkan 5 Dimensi Servqual',
              color: Colors.teal.shade300,
            ),
          ],
        ),
      ],
    );
  }

  Widget gap5VariablesTableServqual() {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Table(
            border: TableBorder.all(
              width: 1,
              color: Colors.black26,
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              chartGap5Servqual.isNotEmpty
                  ? TableRow(
                      children: [
                        ...List.generate(
                          chartGap5Servqual.length,
                          (i) => textColumn(
                            '${chartGap5Servqual[i].x}',
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w900,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.10),
                            ),
                          ),
                        )
                      ],
                    )
                  : TableRow(
                      children: [
                        textColumn(
                          'No Data',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w900,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.10),
                          ),
                        ),
                      ],
                    ),
              chartGap5Servqual.isNotEmpty
                  ? TableRow(
                      children: [
                        ...List.generate(
                          chartGap5Servqual.length,
                          (i) => textColumn(
                            chartGap5Servqual[i].y!.toStringAsFixed(2),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  : TableRow(
                      children: [
                        textColumn(
                          'No Data',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textColumn(
    String text, {
    BoxDecoration? decoration,
    double? fontSize,
    EdgeInsets? padding,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: decoration ?? const BoxDecoration(),
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.left,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
