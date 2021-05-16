import 'package:flutter/material.dart';
import 'package:malaria_fuzzy_expert_system/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Malaria Fuzzy Expert System',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFF4527a0),
        secondaryHeaderColor: Color(0xFF4a148c),
      ),
      home: HomePage(),
    );
  }
}


