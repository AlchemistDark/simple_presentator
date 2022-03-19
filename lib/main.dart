//import 'dart:html';

import 'package:flutter/material.dart';                                        // Стандартная библиотека виджетов.
import 'simple_presentator.dart';                                              // Класс для асинхронной работы со списком задач.
import 'task_widget.dart';                                                     // Класс, где хранится виджет задачи.

void main() {
  final DataSource dataSource = DataSource();
  runApp(MyApp(dataSource));
}

class MyApp extends StatelessWidget {                                          // Приложение.
  final DataSource dataSource;
  MyApp(this.dataSource);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Стрингошлёпалка1',                                               // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,                                      // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка2', dataSource: dataSource),
    );
  }  //Widget build(BuildContext context)
}  //class

class MyHomePage extends StatefulWidget {                                      // Главное окно приложения.
  final String title;
  final DataSource dataSource;
  MyHomePage({Key? key, required this.title, required this.dataSource}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title, dataSource);
}

class _MyHomePageState extends State<MyHomePage> {                             // Здесь описаны парметры (:гражданства:) главного окна.
  final DataSource dataSource;                                                 // Ссылка на источник данных.
  final String title;                                                          // Заголовок главного окна.
  late SimplePresentator present;                                              // Объект потока данных, с которым работают виджеты окна. Класс описан на строке 4.

  int _ind = -1;                                                               // Поле, которое хранит индекс строки списка, которая в данный момент редактируется.
                                                                               // -1 означает, что в данный момент таких строк нет.
  /// Конструктор класса.
  _MyHomePageState(this.title, this.dataSource){
    present = SimplePresentator(dataSource);
  }
  /// Создаёт задачу.
  void _dataAdd(String str) async {
    final task = Task(str);
    await present.create(task);                       // Метод класса из строки 4 для создания задачи.
  }
  /// Меняет значение [Task.isDone] задачи.
  void _checkChanged(Task task) async {
    await present.checkChange(task);                 // Метод класса из строки 4 для редактирования строки списка.
  }
  /// Помечает задачу как редактируемую.
  void _dataChecked(int taskIndex) async {
    _ind = taskIndex;
    await present.loadAll();                          // Это событие нужно чтобы обновить экран. Это метод класса на строке 4.
  }
  /// Редактирует поле [Task.name] задачи.
  void _dataEdit(Task oldTask, String newStr) async {
    final newTask = Task(newStr, oldTask.isDone);
    await present.edit(oldTask, newTask);             // Метод класса из строки 4 для редактирования поля [Task.name] задчи.
    _ind = -1;                                        // Помеяает, что больше пока задачи не редактируются.
  }
  /// Удаляет задачу.
  void _dataDelete(Task task) async {
    await present.delete(task);                       // Метод класса из строки 4 для удаления строки списка.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child:
            StreamBuilder<TasksViewModel>(
              initialData: present.lastState,
              stream: present.states,
              builder: (context, snapShot) {
                final lst = snapShot.data!;
                ListView lV = ListView.builder(
                  itemCount: lst.items.length,                                 // Эта строка сообщает ListView.builder сколько всего элементов в списке.
                  itemBuilder: (BuildContext context, int index) {
                    String _str = lst.items[index].name;
                    print('строка $_str, $index, $_ind');
                    bool _isEditMode = _ind == index;
                    return TaskWidget(                                         // Виджет описан в классе на строке 5.
                      isChecked: lst.items[index].isDone,
                      isEditMode: _isEditMode,
                      str: lst.items[index].name,
                      onCheckChanged: (bool) {_checkChanged(lst.items[index]);},         // Строка ~55. callBack.
                      onSelected: () {_dataChecked(index);},                             // Строка ~60. callBack.
                      onEdited: (text) {_dataEdit(lst.items[index], text);},             // Строка ~65. callBack.
                      onDeleted: () {_dataDelete(lst.items[index]);},                    // Строка ~75. callBack.
                    );
                  }
                );
                return lV;
              },
            )
          ),
          TextField(
            controller: TextEditingController(),       // Эта хрень нужна что бы чисть поле после каждого ввода.
            onSubmitted: (text){
              setState(() {
                _dataAdd(text);                        // Добавляет таск в tasks (строка ~50)
                TextEditingController().text = " ";    // Эта хрень чистит поле после каждого ввода.
              });                                      // В конце setState обновляет виджет.
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Введите таску",
            ),
          )
        ]
      ),
      appBar: AppBar(title: Text(title))               // Заголовок окна.
    );
  }
}



