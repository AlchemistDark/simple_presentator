//import 'dart:html';

import 'package:flutter/material.dart';
import 'simple_presentator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Стрингошлёпалка1',                    // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,           // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка2'),  // Скорее всего это имя главного окна.
    );
  }  //Widget build(BuildContext context)
}  //class

class MyHomePage extends StatefulWidget {           // Я нихрена не понимаю что я тут делаю >_<
                                                    // но это какой-то флаттеровский костыль.
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Поля класса
  // Здесь может быть что-то про поля класса.
  SimplePresentator present = SimplePresentator(Proxy()); // Данное поле это объект потока данных. Класс описан на строке 4.
  // Здесь может что-то быть.

  // Методы класса
  // Здесь может что-то быть.
  void _dataAdd(str) async {
    await present.create(str);
  }
  // Здесь может что-то быть.

  // Конструктор.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // Здесь может что-то быть.
        children: [
          Expanded(child:
            StreamBuilder<List<String>>(
              initialData: [],
              stream: present.sData,
              builder: (context, snapShot) {        // Здесь должно быть много кода по превращению потока в виджет...
                List<String> lst = snapShot.data!;
                ListView lV = ListView.builder(
                  itemCount: lst.length,            // Эта строка сообщает ListView.builder сколько всего элементов в списке.
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        ElevatedButton.icon(
                          onPressed: (){},  // TODO Здесь должна быть функция редактирования строки.
                          style: ElevatedButton.styleFrom(primary: Colors.green, fixedSize: Size(5, 5)),
                          icon: Icon(Icons.edit),
                          label: Text("")
                        ),
                        ElevatedButton.icon(
                          onPressed: (){},  // TODO Здесь должна быть функция удаления строки.
                          style: ElevatedButton.styleFrom(primary: Colors.red, fixedSize: Size(20, 20)),
                          icon: Icon(Icons.remove),
                          label: Text("")
                        ),
                        Text(lst[index]),
                      ],
                    );
                  }
                );
                return lV;
              },
            )
          ),
          TextField(
            controller: TextEditingController(),    // Эта хрень нужна что бы чисть поле после каждого ввода.
            onSubmitted: (text){
              setState(() {
                _dataAdd(text);                     // Добавляет таск в tasks (строка 34)
                TextEditingController().text = " "; // Эта хрень чистит поле после каждого ввода.
              });                                   // В конце setState обновляет виджет.
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Введите таску",
            ),
          )
        ]
         // Здесь может что-то быть.
      ),
      appBar: AppBar(title: const Text('Стрингошлёпалка3')) // Заголовок окна.
    );
  }
  // Здесь может что-то быть.
}