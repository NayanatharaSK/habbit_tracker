import 'package:habbit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //create initial default data
  void createDefaultData() {
    todayHabitList = [
      ["Run", false],
      ["Read", false],
    ];

    _myBox.put("START_DATE", todayDateFormatted());
  }

  //load data if it already exists
  void loadData() {
    //if its a new day, get habit list from database
    if (_myBox.get(todayDateFormatted()) == null) {
      todayHabitList = _myBox.get("CURRENT_HABIT_LIST");
      //SET ALL HABIT COMPLETED TO FALSE SINCE IT'S A NEW DAY
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[1][1] = false;
      }
    }
    //if its not a new day, load todays list
    else {
      todayHabitList = _myBox.get(todayDateFormatted());
    }
  }

  //update database
  void updateDatabase() {
// update todays entry
    _myBox.put(todayDateFormatted(), todayHabitList);

//update universal habit list in case it changed(new habit,edit habit,delete habit)
    _myBox.put("CURRENT_HABIT_LIST", todayHabitList);

    //Calculate habit complete precentages for each day
    CalculateHabitPrecentages();

    //load heat map
    loadHeatMap();
  }

  void CalculateHabitPrecentages() {
    int countCompleted = 0;
    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todayHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todayHabitList.length).toStringAsFixed(1);

    //key: "PERCENTAGE_SUMMARY_YYYYMMDD"
    //value: String of 1dp number between 0-1 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todayDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start date to today and ad each percentage to the dataset
    //"PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

//split the datetime up like below so it doesn't worry about hours/mins/secs etc.

//year
      int year = startDate.add(Duration(days: i)).year;
//month
      int month = startDate.add(Duration(days: i)).month;

//day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
