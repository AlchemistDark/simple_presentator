import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simp Present',           // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,    // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка'),
    );
  }  //Widget build(BuildContext context)
}  //class

class MyHomePage extends StatefulWidget {  // Я нихрена не понимаю что я тут делаю >_<
  // но это какой-то флаттеровский костыль.
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Здесь может что-то быть.
  @override
  Widget build(BuildContext context) {
    return Scaffold(); // Здесь должно что-то быть.
  }
  // Здесь может что-то быть.
}