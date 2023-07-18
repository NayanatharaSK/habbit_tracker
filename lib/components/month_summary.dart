import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habbit_tracker/datetime/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    required this.datasets,
    required this.startDate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(20, 60, 9, 108), // Color with alpha 20
          2: Color.fromARGB(40, 60, 9, 108), // Color with alpha 40
          3: Color.fromARGB(60, 60, 9, 108), // Color with alpha 60
          4: Color.fromARGB(80, 60, 9, 108), // Color with alpha 80
          5: Color.fromARGB(100, 60, 9, 108), // Color with alpha 100
          6: Color.fromARGB(120, 60, 9, 108), // Color with alpha 120
          7: Color.fromARGB(150, 60, 9, 108), // Color with alpha 150
          8: Color.fromARGB(180, 60, 9, 108), // Color with alpha 180
          9: Color.fromARGB(220, 60, 9, 108), // Color with alpha 220
          10: Color.fromARGB(240, 60, 9, 108), // Color with alpha 240
        },
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
