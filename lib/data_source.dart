import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_presentator/simple_presentator.dart';

/// Класс источника данных. Его экземпляр хранит список весх существующих задач.
/// Первым методом вызываемым при работе с этим классом обязательно должен быть .start().
class DataSource{

  /// Список всех задач.
  final List<Task> taskList = [];
  /// Список всех задач в ввиде списка строк.
  List<String> stringList = [];

  /// Источник данных.
  late final SharedPreferences _source;

  /// Функция для связи приложения с источником данных.
  Future<void> start() async {
    _source = await SharedPreferences.getInstance();
    _toTask();
    print("БД подключена, список задач: $taskList $stringList");
  }
  /// Выдаёт актуальный список задач.
  Future<List<Task>> readAll() async {
    _toTask();
    return taskList;
  }
  /// Превращет возвращаемый список строк в список задач.
  void _toTask() {
    final List<String> _list = _source.getStringList('Task list') ?? [];
    for (int i = 0; i < _list.length; i++) {
      Task tempTask = Task(_list[i]);
      print(tempTask.name); // для отладки
      taskList.add(tempTask);
    }
  }
  /// Превращает список задач обратно в список строк.
  void _toString() {
    List<String> _tempList = [];
    for (int i = 0; i < taskList.length; i++) {
      _tempList.add(taskList[i].name);
    }
    print(_tempList); // для отладки
    stringList = _tempList;
  }
  /// Создаёт задачу.
  Future<void> create(Task task) async {
    taskList.add(task);
    //_toString();
    await _source.setStringList('Task list', [task.name]);
  }

  // todo

  /// Редактирует задачу.
  Future<List<Task>> edit(Task oldTask, Task newTask) async {
  await Future.delayed(Duration(milliseconds: 50));
  int _i = taskList.indexOf(oldTask);
  taskList[_i] = newTask;
  return taskList;
  }
  /// Удаляет задачу.
  Future<List<Task>> delete(List<int> indexes) async {
  await Future.delayed(Duration(milliseconds: 30));
  indexes.sort();
  for (; indexes.length > 0 ;){
  print(indexes[indexes.length-1]);
  int _i = indexes[indexes.length-1];
  print (taskList[_i].name);
  taskList.removeAt(indexes[indexes.length-1]);
  indexes.removeAt(indexes.length-1);
  print(taskList);
  print(indexes);
  }
  return taskList;
  }
}

