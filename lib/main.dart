import 'package:flutter/material.dart';
import 'package:tagmee/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tagmee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nova'
      ),
      home: HomeScreen(),
    );
  }
}
