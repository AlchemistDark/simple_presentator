//import 'dart:html';

import 'package:flutter/material.dart';                    // Стандартная библиотека виджетов.
import 'package:simple_presentator/task_edit_dialog.dart'; // Класс окна редактирования задач.
import 'simple_presentator.dart';                          // Класс для асинхронной работы со списком задач.
import 'task_widget.dart';                                 // Класс, где хранится виджет задачи.

void main() {
  final DataSource dataSource = DataSource();
  runApp(MyApp(dataSource));
}

/// Приложение.
class MyApp extends StatelessWidget {
  final DataSource dataSource;
  MyApp(this.dataSource);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Стрингошлёпалка1',                           // Заголовок окна с программой.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,                  // Цвет элементов окна.
      ),
      home: MyHomePage(title: 'Стрингошлёпалка2', dataSource: dataSource),
    );
  }  //Widget build(BuildContext context)
}  //class

/// Главное окно приложения.
class MyHomePage extends StatefulWidget {
  final String title;
  final DataSource dataSource;
  MyHomePage({Key? key, required this.title, required this.dataSource}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title, dataSource);
}

/// State главного окна приложения.
class _MyHomePageState extends State<MyHomePage> {
  /// Ссылка на источник данных.
  final DataSource dataSource;
  /// Заголовок главного окна.
  final String title;
  /// Объект потока данных, с которым работают виджеты окна. Класс описан на строке 4.
  late SimplePresentator present;
  /// Здесь хранится список индексов выделенных задач.
  /// -1 означает, что в данный момент таких задач нет.
  List<int> _selectedTasksIndexes = [];
  /// Здесь хранится ссылка на выбранную  задачу (ссылка передаётся в AppBar, когда её индекс совпадает _indTaped).
  Task _selectedTask = Task("name");

  /// Конструктор класса.
  _MyHomePageState(this.title, this.dataSource){
    present = SimplePresentator(dataSource);
  }
  /// Создаёт задачу.
  void _dataAdd(String str) async {
    final task = Task(str);
    await present.create(task);                            // Метод класса из строки 4 для создания задачи.
  }
  /// Выделяет задачу.
  void _onTaped(Task task, int index){
    _selectedTask = task;
    if (_selectedTasksIndexes.contains(index)) {
      _selectedTasksIndexes.remove(index);
    } else {
      _selectedTasksIndexes.add(index);
    }
  }
  /// Удаляет задачу.
  void _dataDelete() async {
    List<int> _indexes = [];
    for (int i = 0; i < _selectedTasksIndexes.length; i++) {
      _indexes.add(_selectedTasksIndexes[i]);
    }
    await present.delete(_indexes);
    _selectedTasksIndexes.clear();
  }
  /// Помечает задачу как Editable и открывает в окно TaskEditDialog.
  void _onAppBarEditPressed(Task task) async {
    final page = MaterialPageRoute<Task>(
      builder: (BuildContext context) {
        return TaskEditDialog(task: task);
      }
    );
    final result = await Navigator.of(context).push<Task>(page);
    if (result != null) {
      print("got from dialog: ${result.status}");
      present.edit(task, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible (child:
            StreamBuilder<TasksViewModel>(
              initialData: present.lastState,
              stream: present.states,
              builder: (context, snapShot) {
                final lst = snapShot.data!;
                ListView lV = ListView.builder(
                  itemCount: lst.items.length,                                           // Эта строка сообщает ListView.builder сколько всего элементов в списке.
                  itemBuilder: (BuildContext context, int index) {
                    return TaskWidget(                                                   // Виджет описан в классе на строке 5.
                      task: lst.items[index],
                      isSelected: _selectedTasksIndexes.contains(index),
                      onSelected: (){setState((){_onTaped(lst.items[index], index);});}, // Строка ~65. callBack.
                    );
                  }
                );
                return lV;
              },
            )
          ),
          TextField(
            controller: TextEditingController(),           // Эта хрень нужна что бы чисть поле после каждого ввода.
            onSubmitted: (text){
              setState(() {
                _dataAdd(text);                            // Добавляет таск в tasks (строка ~60)
                TextEditingController().text = " ";        // Эта хрень чистит поле после каждого ввода.
              });                                          // В конце setState обновляет виджет.
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Введите таску",
            ),
          )
        ]
      ),
      appBar: _buildAppBar()
    );
  }

  AppBar _buildAppBar() {
    final showDeleteButton = _selectedTasksIndexes.isNotEmpty;
    final showEditButton = _selectedTasksIndexes.length == 1;

    return AppBar(
      title: Text(title),                                // Заголовок окна.
      actions: [
        /// Кнопка редактирования задачи.
        if (showEditButton) Container(
          padding: EdgeInsets.all(5),
          child:  ElevatedButton.icon(
            onPressed: (){_onAppBarEditPressed(_selectedTask);},
            icon: Icon(Icons.edit),
            label: Text("")
          )
        ),
        /// Кнопка удаления задачи.
        if (showDeleteButton) Container(
          padding: EdgeInsets.all(5),
          child: ElevatedButton.icon(
            onPressed: (){
              print("кнопка удаления $_selectedTasksIndexes");
              setState(() {                               // В конце setState обновляет виджет.
                _dataDelete();               // Строка ~75.
              });
            },
            icon: Icon(Icons.remove),
            label: Text("")
          )
        ),
        /// Кнопка отмены выделения.
        if (showDeleteButton) Container(
          padding: EdgeInsets.all(5),
          child: ElevatedButton.icon(
            onPressed: (){
              setState(() {                                                // В конце setState обновляет виджет.
                _selectedTasksIndexes = [];
              });
            },
            icon: Icon(Icons.radio_button_unchecked),
            label: Text("")
          )
        )
      ],
    );
  }
}



