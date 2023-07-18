import 'package:flutter/material.dart';
import 'package:habbit_tracker/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  //initialize hive
  await Hive.initFlutter();

  //open  a box
  await Hive.openBox("Habit_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
