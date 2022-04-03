//import 'dart:html';

import 'package:flutter/material.dart';                    // Стандартная библиотека виджетов.
import 'package:simple_presentator/task_edit_dialog.dart';
import 'simple_presentator.dart';                          // Класс для асинхронной работы со списком задач.
import 'task_widget.dart';                                 // Класс, где хранится виджет задачи.

void main() {
  final DataSource dataSource = DataSource();
  runApp(MyApp(dataSource));
}

class MyApp extends StatelessWidget {                      // Приложение.
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

class MyHomePage extends StatefulWidget {                  // Главное окно приложения.
  final String title;
  final DataSource dataSource;
  MyHomePage({Key? key, required this.title, required this.dataSource}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title, dataSource);
}

class _MyHomePageState extends State<MyHomePage> {         // Здесь описаны парметры (:гражданства:) главного окна.
  final DataSource dataSource;                             // Ссылка на источник данных.
  final String title;                                      // Заголовок главного окна.
  late SimplePresentator present;                          // Объект потока данных, с которым работают виджеты окна. Класс описан на строке 4.

  //int _indSelected = -1;                                   // Поле, которое хранит индекс строки списка, которая в данный момент тапнута.
                                                           // Задача с этим индексом передаётся в AppBar.
  /// Здесь хранится список индексов выделенных задач.
  final List<int> selectedTaskIndex = [];
                                                           // -1 означает, что в данный момент таких задач нет.
  Task _selectedTask = Task("name");                       // Здесь хранится ссылка на выбранную  задачу (ссылка передаётся в AppBar, когда её индекс совпадает _indTaped).

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
   // _indSelected = index;
    if (selectedTaskIndex.contains(index)) {
      selectedTaskIndex.remove(index);
    } else {
      selectedTaskIndex.add(index);
    }
  }
  /// Меняет значение [Task.isDone] задачи.
  void _checkChanged(Task task) async {
    await present.checkChange(task);                       // Метод класса из строки 4 для редактирования строки списка.
  }
  /// Редактирует поле [Task.name] задачи.
  // void _dataEdit(Task oldTask, String newStr) async {
  //   final newTask = Task(newStr, oldTask.isDone);
  //   await present.edit(oldTask, newTask);                  // Метод класса из строки 4 для редактирования поля [Task.name] задчи.
  //   selectedTaskIndex.clear();                                     // Помеяает, что больше пока задачи не редактируются.
  //}
  /// Удаляет задачу.
  void _dataDelete(Task task) async {
    await present.delete(task);                            // Метод класса из строки 4 для удаления строки списка.
    selectedTaskIndex.clear();                                     // Помеяает, что больше пока задачи не редактируются.
  }
  /// Помечает задачу как Editable.
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
                    print('строка $_str, $index, $selectedTaskIndex _indSelected');
                    return TaskWidget(                                         // Виджет описан в классе на строке 5.
                      task: lst.items[index],
                      isSelected: selectedTaskIndex.contains(index),
                      onSelected: (){setState((){_onTaped(lst.items[index], index);});}, // Строка ~60. callBack.
                      onIsDoneChanged: (bool) {_checkChanged(lst.items[index]);},         // Строка ~65. callBack.
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
                _dataAdd(text);                            // Добавляет таск в tasks (строка ~55)
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
    final showDeleteButton = selectedTaskIndex.isNotEmpty;//    _indSelected != -1;
    final showEditButton = selectedTaskIndex.length == 1;//_indSelected != -1;

    return AppBar(
      title: Text(title),                                // Заголовок окна.
      actions: [
        if (showEditButton) ElevatedButton.icon(
          onPressed: (){_onAppBarEditPressed(_selectedTask);},
          style: ElevatedButton.styleFrom(
            primary: Colors.green[400],
            fixedSize: Size(3, 3)
          ),
          icon: Icon(Icons.edit),
          label: Text("")
        ),
        if (showDeleteButton) ElevatedButton.icon(
          onPressed: (){
            setState(() {                               // В конце setState обновляет виджет.
              _dataDelete(_selectedTask);               // Строка ~75.
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red[900],
            fixedSize: Size(20, 20)
          ),
          icon: Icon(Icons.remove),
          label: Text("")
        ),
      ],
    );
  }
}



