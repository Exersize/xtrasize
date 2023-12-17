import 'package:flutter/material.dart';
import 'package:flutter_application_1/datetime/date_time.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
    }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[400],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        colorsets: const{
          1: Colors.green,
          2: Colors.red,
        },


      ),
    );
  }
}