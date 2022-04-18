//import 'dart:html';

import 'package:flutter/material.dart';                              // Стандартная библиотека виджетов.
import 'package:simple_presentator/task.dart';                       // Класс задачи.
import 'package:simple_presentator/task_edit_dialog.dart';           // Класс окна редактирования задач.
import 'package:simple_presentator/simple_presentator.dart';         // Класс для асинхронной работы со списком задач.
import 'package:simple_presentator/task_widget.dart';                // Класс, где хранится виджет задачи.
//import 'package:simple_presentator/data_source.dart';                // Класс, где хранится список задач.
import 'package:shared_preferences/shared_preferences.dart';         // Класс для работы с базой данных.


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
  final DataSource dataSource; // todo Возможно устареет.
  /// Заголовок главного окна.
  final String title;
  /// Объект потока данных, с которым работают виджеты окна. Класс описан на строке 4.
  late SimplePresentator present;

  /// Ссылка на объект базы данных.
  late final SharedPreferences _data;
  /// Здесь хранится список индексов выделенных задач.
  /// -1 означает, что в данный момент таких задач нет.
  List<int> _selectedTasksIndexes = [];
  /// Здесь хранится ссылка на выбранную  задачу (ссылка передаётся в AppBar, когда её индекс совпадает _indTaped).
  Task _selectedTask = Task("name");
  /// Флаг того, что все данные для переменных, загружемые из базы данных, загружены, а сами переменные инициализированы.
  bool _init = false; //

  /// Конструктор класса.
  _MyHomePageState(this.title, this.dataSource){
    //present = SimplePresentator(dataSource, _data);
  }

  /// Проводит отложенную инициализацию для полей класса, тип которых нужно получить из Future.
  /// Потом устанавливает флаг что инициализация этих полей закончена.
  Future<void> _initialise() async {
    _data = await SharedPreferences.getInstance(); // Ссылка на объект базы данных.
    present = SimplePresentator(dataSource, _data);
    _init = true;
    setState((){});
  }

  @override
  void initState(){
    super.initState();
    _initialise();
  }

  /// Создаёт задачу.
  void _dataAdd(String str) async {
    final task = Task(str);
    await present.create(task);                            // Метод класса из строки 4 для создания задачи.
    print("имя последней таски ${present.taskString}");
    setState(() {});
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

  /// Возвращает главный элемент главного окна.
  Widget mySteam() {
    if (_init) {
      return Column(
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
                      onSelected: (){setState((){_onTaped(lst.items[index], index);});}, // Строка ~90. callBack.
                    );
                  }
                );
                return lV;
              },
            )
          ),
          Text('${present.taskString}'),
          TextField(
            controller: TextEditingController(),           // Эта хрень нужна что бы чисть поле после каждого ввода.
            onSubmitted: (text){
              setState(() {
                _dataAdd(text);                            // Добавляет таск в tasks (строка ~85)
                TextEditingController().text = " ";        // Эта хрень чистит поле после каждого ввода.
              });                                          // В конце setState обновляет виджет.
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Введите таску",
            ),
          )
        ]
      );
    }
    return Text("Грузиццо...", style: Theme.of(context).textTheme.headline4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mySteam(),
      appBar: _buildAppBar()
    );
  }

  /// AppBar у нас кастомный.
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
                _dataDelete();               // Строка ~100.
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