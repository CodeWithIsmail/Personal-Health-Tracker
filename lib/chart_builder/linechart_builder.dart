import '../ImportAll.dart';

class CustomLineChart extends StatelessWidget {
  String chartTitle, uname;
  List<ChartDataTimewise> dataList;

  CustomLineChart(this.chartTitle, this.uname, this.dataList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SfCartesianChart(
        title: ChartTitle(
          text: chartTitle,
          textStyle: TextStyle(
            color: Colors.green.shade900,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        plotAreaBorderWidth: 0,
        borderColor: Colors.brown,
        borderWidth: 1.35,
        backgroundColor: Colors.white,
        primaryXAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            final date =
            DateTime.fromMillisecondsSinceEpoch(details.value.toInt());
            return ChartAxisLabel(
                DateFormat('dd-MMM-yy').format(date), const TextStyle());
          },
          title: const AxisTitle(text: 'Date'),
        ),
        primaryYAxis: const NumericAxis(
          decimalPlaces: 0,
          labelFormat: '{value}',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent),
        ),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        tooltipBehavior: TooltipBehavior(
          duration: 6000,
          enable: true,
          tooltipPosition: TooltipPosition.pointer,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            final date =
            DateTime.fromMillisecondsSinceEpoch(point.x.toInt());
            final valueToDisplay = data.value.toInt();
            final name = uname;
            final seriesColor = series.color;

            return Container(
              decoration: BoxDecoration(
                color: seriesColor,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$chartTitle\n'
                    '${DateFormat('dd MMM yyyy').format(date)} : $valueToDisplay',
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            );
          },
        ),
        // zoomPanBehavior: ZoomPanBehavior(
        //   enablePanning: true,
        //   enablePinching: true,
        //   enableDoubleTapZooming: true,
        //   enableSelectionZooming: true,
        // ),
        crosshairBehavior: CrosshairBehavior(
          activationMode: ActivationMode.doubleTap,
          enable: true,
          lineColor: Colors.green,
          lineWidth: 1,
        ),
        series: <CartesianSeries>[
          LineSeries<ChartDataTimewise, num>(
            name: uname,
            dataSource: dataList,
            xValueMapper: (ChartDataTimewise data, int index) => data.time,
            yValueMapper: (ChartDataTimewise data, int index) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}
