//import 'dart:html';

import 'package:flutter/material.dart';                                     // Стандартная библиотека виджетов.
import 'simple_presentator.dart';                                           // Класс для асинхронной работы со списком строк.

void main() {
  final DataSource dataSource = DataSource();
  runApp(MyApp(dataSource));
}

class MyApp extends StatelessWidget {
  final DataSource dataSource;
  MyApp(this.dataSource);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Стрингошлёпалка1',                                            // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,                                   // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка2', dataSource: dataSource),  // Скорее всего это имя главного окна.
    );
  }  //Widget build(BuildContext context)
}  //class

class MyHomePage extends StatefulWidget {
  final String title;
  final DataSource dataSource;
  MyHomePage({Key? key, required this.title, required this.dataSource}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(dataSource);
}

class _MyHomePageState extends State<MyHomePage> {
  final DataSource dataSource;
  int _ind = -1;                                     // Поле, которое хранит индекс строки списка, которая в данный момент редактируется.
  // -1 означает, что в данный момент таких строк нет.
  late SimplePresentator present;                    // Данное поле это объект потока данных. Класс описан на строке 4.
  _MyHomePageState(this.dataSource){
    present = SimplePresentator(dataSource);
  }

  void _dataAdd(String str) async {                            // Создаёт строку списка.
    await present.create(str);                                 // Метод класса из строки 4 для создания строки списка.
  }
  void _dataChecked(int editedIndex, int stringIndex) async {  // Помечает строку как редактируемую.
    editedIndex = stringIndex;
    print("Start $editedIndex $stringIndex");
    await present.loadAll();                                   // Это событие нужно чтобы обновить экран. Это метод класса на строке 4.
    print("End $editedIndex $stringIndex");
  }
  void _dataEdit(String oldStr, String newStr) async {         // Редактирует строку.
    await present.edit(oldStr, newStr);                        // Метод класса из строки 4 для редактирования строки списка.
  }
  void _dataDelete(String str) async {                         // Удалаяет строку.
    await present.delete(str);                                 // Метод класса из строки 4 для удаления строки списка.
  }

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
              builder: (context, snapShot) {              // Здесь должно быть много кода по превращению потока в виджет...
                List<String> lst = snapShot.data!;
                ListView lV = ListView.builder(
                  itemCount: lst.length,            // Эта строка сообщает ListView.builder сколько всего элементов в списке.
                  itemBuilder: (BuildContext context, int index) {
                    if (_ind == index) {
                      return MyTextField(
                        str: lst[index],
                        callBackEdit: (text) {_dataEdit(lst[index], text);},     // Строка ~45. Праметр text должен как-то импортироваться из виджета, который сам в другом классе.
                      ) ;
                    }
                    return MyRow(
                      str: lst[index],
                      callBackChecked: () {_dataChecked(_ind, index);},        // Строка ~40.
                      callBackDelete: () {_dataDelete(lst[index]);},           // Строка ~50.
                    );
                  }
                );
                print(lV);
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
      ),
      appBar: AppBar(title: const Text('Стрингошлёпалка3')) // Заголовок окна.
    );
  }
}

class MyTextField extends StatelessWidget {
  final String str;                               // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final callBackEdit;                             // Сюда передаётся функция редактирования строки.

  const MyTextField({Key? key, required this.str, required this.callBackEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: callBackEdit,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: str)
    );
  }
}

class MyRow extends StatelessWidget {
  final String str;                               // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final callBackChecked;                          // Сюда передаётся функция, помечающая строку как редактируемую.
  final callBackDelete;                           // Сюда передаётся функция удаления строки.

  const MyRow({Key? key,  required this.str, required this.callBackChecked, required this.callBackDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        ElevatedButton.icon(
            onPressed: callBackChecked,
            style: ElevatedButton.styleFrom(primary: Colors.green, fixedSize: Size(5, 5)),
            icon: Icon(Icons.edit),
            label: Text("")
        ),
        ElevatedButton.icon(
            onPressed: callBackDelete,
            style: ElevatedButton.styleFrom(primary: Colors.red, fixedSize: Size(20, 20)),
            icon: Icon(Icons.remove),
            label: Text("")
        ),
        Text(str),
      ],
    );
  }
}


