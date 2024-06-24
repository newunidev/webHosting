import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class PieChartWidget extends StatefulWidget {
  final List<PieChartSectionData> Function() createPieChartSections;


  const PieChartWidget({Key? key,required this.createPieChartSections}) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {




  @override
  Widget build(BuildContext context) {
    return Container(
      child: PieChart(
        PieChartData(
          sections: widget.createPieChartSections(),
          centerSpaceRadius: 0.0,
          borderData: FlBorderData(
            show: true,
            border: Border.all(

              color: Colors.black, // Set your desired border color
              width: 2.0, // Set your desired border width
            ),

          ),
        ),
      ),
    );
  }


}
