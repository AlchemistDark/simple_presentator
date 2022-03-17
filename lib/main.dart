//import 'dart:html';

import 'package:flutter/material.dart';                                        // Стандартная библиотека виджетов.
import 'simple_presentator2.dart';                                              // Класс для асинхронной работы со списком строк.
import 'string_widget.dart';                                                   // Класс, где хранится виджет строки списка.

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
      title: 'Стрингошлёпалка1',                                               // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,                                      // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка2', dataSource: dataSource),     // Скорее всего это имя главного окна.
    );
  }  //Widget build(BuildContext context)
}  //class

class MyHomePage extends StatefulWidget {
  final String title;
  final DataSource dataSource;
  MyHomePage({Key? key, required this.title, required this.dataSource}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title, dataSource);
}

class _MyHomePageState extends State<MyHomePage> {
  final DataSource dataSource;
  final String title;
  int _ind = -1;                                     // Поле, которое хранит индекс строки списка, которая в данный момент редактируется.
                                                     // -1 означает, что в данный момент таких строк нет.
  late SimplePresentator present;                    // Данное поле это объект потока данных. Класс описан на строке 4.
  _MyHomePageState(this.title, this.dataSource){
    present = SimplePresentator(dataSource);
  }

  void _dataAdd(String str) async {                            // Создаёт строку списка.
    final task = Task(str);
    await present.create(task);                                 // Метод класса из строки 4 для создания строки списка.
  }
  void _dataChecked(int taskIndex) async {                   // Помечает строку как редактируемую.
    _ind = taskIndex;
    await present.loadAll();                                   // Это событие нужно чтобы обновить экран. Это метод класса на строке 4.
  }
  void _dataEdit(Task oldTask, String newStr) async {         // Редактирует строку.
    final newTask = Task(newStr);
    await present.edit(oldTask, newTask);                        // Метод класса из строки 4 для редактирования строки списка.
    _ind = -1;
  }
  void _dataDelete(Task task) async {                         // Удалаяет строку.
    await present.delete(task);                                 // Метод класса из строки 4 для удаления строки списка.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // Здесь может что-то быть.
        children: [
          Expanded(child:
            StreamBuilder<TasksViewModel>(
              initialData: present.lastState,
              stream: present.states,
              builder: (context, snapShot) {                  // Здесь должно быть много кода по превращению потока в виджет...
                final lst = snapShot.data!;
                ListView lV = ListView.builder(
                  itemCount: lst.items.length,                      // Эта строка сообщает ListView.builder сколько всего элементов в списке.
                  itemBuilder: (BuildContext context, int index) {
                    String _str = lst.items[index].name;
                    print('строка $_str, $index, $_ind');
                    bool _isEditMode = _ind == index;
                    return StringWidget(                                       // Виджет описан в классе на строке 5.ь
                      isEditMode: _isEditMode,
                      str: lst.items[index].name,
                      onSelected: () {_dataChecked(index);},                   // Строка ~40. callBack.
                      onEdited: (text) {_dataEdit(lst.items[index], text);},         // Строка ~45. callBack.
                                                                               // Праметр text должен как-то импортироваться из виджета, который сам в другом классе.
                      onDeleted: () {_dataDelete(lst.items[index]);},                // Строка ~50. callBack.
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
      appBar: AppBar(title: Text(title))                    // Заголовок окна.
    );
  }
}



