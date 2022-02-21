//import 'dart:html';

import 'package:flutter/material.dart';             // Стандартная библиотека виджетов.
import 'simple_presentator.dart';                   // Класс для асинхронной работы со списком строк.
import 'string_widget.dart';                        // Класс, где хранится виджет строки списка.

void main() {
  final DataSource dataSource = DataSource();
  runApp(MyApp());
}

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
  final String title;
  MyHomePage({Key? key, required this.title}) : super(key: key);
  @override

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _ind = -1;      // Поле, которое хранит индекс строки списка, которая в данный момент редактируется.
                      // -1 означает, что в данный момент таких строк нет.
  SimplePresentator present = SimplePresentator(Proxy());      // Данное поле это объект потока данных. Класс описан на строке 4.

  void _dataAdd(String str) async {                            // Создаёт строку списка.
    await present.create(str);                                 // Метод класса из строки 4 для создания строки списка.
  }
  void _dataChecked(int editedIndex, int stringIndex) async {  // Помечает строку как редактируемую.
    editedIndex = stringIndex;
    await present.loadAll();                                   // Это событие нужно чтобы обновить экран. Это метод класса на строке 4.
  }
  void _dataEdit(String oldStr, String newStr) async {         // Редактирует строку.
    await present.edit(oldStr, newStr);                        // Метод класса из строки 4 для редактирования строки списка.
  }
  void _dataDelete(String str) async {                         // Удалаяет строку.
    await present.delete(str);                                 // Метод класса из строки 4 для удаления строки списка.
  }

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
              builder: (context, snapShot) {                  // Здесь должно быть много кода по превращению потока в виджет...
                List<String> lst = snapShot.data!;
                ListView lV = ListView.builder(
                  itemCount: lst.length,                      // Эта строка сообщает ListView.builder сколько всего элементов в списке.
                  itemBuilder: (BuildContext context, int index) {
                    String _str = lst[index];
                    print('строка $_str, $index, $_ind');
                    bool _isEditable = _ind == index;
                    return StringWidget(                                       // Виджет описан в классе на строке 5.ь
                      isEditable: _isEditable,
                      str: lst[index],
                      callBackChecked: () {_dataChecked(_ind, index);},        // Строка ~40.
                      callBackEdit: (text) {_dataEdit(lst[index], text);},     // Строка ~45. Праметр text должен как-то импортироваться из виджета, который сам в другом классе.
                      callBackDelete: () {_dataDelete(lst[index]);},           // Строка ~50.
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
      ),
      appBar: AppBar(title: const Text('Стрингошлёпалка3')) // Заголовок окна.
    );
  }
}



