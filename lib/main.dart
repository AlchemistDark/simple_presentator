//import 'dart:html';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Стрингошлёпалка1',           // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,    // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка2'),  // Скорее всего это имя главного окна.
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
    return Scaffold(
      body: Column(
        // Здесь может что-то быть.
        children: [
          Flexible(child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Text("Pass"); // TODO Здесь будет что-то умнее.
            }
          ))
        ]
         // Здесь может что-то быть.
      ),
      appBar: AppBar(title: const Text('Стрингошлёпалка3')) // Заголовок окна.
    );
  }
  // Здесь может что-то быть.
}