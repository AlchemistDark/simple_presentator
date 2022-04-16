import 'dart:async';
//import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_presentator/data_source.dart';

/// Класс представления данных.
class SimplePresentator{
  /// Поля интерфейса класса.
  // Объект, с которым работает stream.
  late TasksViewModel lastState;
  // Создаём stream.
  Stream<TasksViewModel> get states => _ctrl.stream;

  /// Приватные поля класса.
  // Создаём контроллер этого stream.
  StreamController<TasksViewModel> _ctrl = StreamController<TasksViewModel>.broadcast();
  // Здесь хранятся все записи, полученные из _px._list.
  late Proxy _px;
  
  @deprecated
  late int counter;
  @deprecated
  late String taskString;

  // Ссылка на DataSource.
  final DataSource _ds;
  // Ссылка на объект базы данных.
  final SharedPreferences _data;  


  /// Конструктор класса.
  SimplePresentator(this._ds, this._data){
    _px = Proxy(_ds, _data);
    counter = _px.counter;
    taskString = _px.taskString;
    lastState = TasksViewModel([]);
    loadAll();
  }

  /// Обновляет последнее событие потока.
  void _fireEvent(List<Task> updatedList) {
    lastState = TasksViewModel(updatedList.toList());
    _ctrl.add(lastState);
  }
  /// Получает актуальный список задач.
  Future<void> loadAll() async {
    final List<Task> updatedList =  await _px.loadAll();
    _fireEvent(updatedList);
  }
  /// Создаёт задачу.
  Future<void> create(Task task) async {
    final List<Task> updatedList = await _px.create(task);
    _fireEvent(updatedList);
    counter = _px.counter;
    taskString = _px.taskString;
    print("что-то не так $taskString, ${_px.taskString}, $counter, ${_px.counter}");
  }

  /// Редактирует задачу.
  Future<void> edit(Task oldTask, Task newTask) async {
    final List<Task> updatedList = await _px.edit(oldTask, newTask);
    _fireEvent(updatedList);
  }
  /// Удаляет задачу.
  Future<void> delete(List<int> indexes) async {
    final List<Task> updatedList = await _px.delete(indexes);
    _fireEvent(updatedList);
  }
  /// Закрывает stream.
  void discard(){
    _ctrl.close();
  }
}

/// Класс, преобразующий задачу для вывода (например, в консоль или в специальный виджет).
class TasksViewModel {
  final List<Task> items;
  TasksViewModel(this.items);
}

/// Возвращает строку, соответсвующую статусу задачи.
String statusToString(TaskStatusEnum status) {
  switch (status){
    case TaskStatusEnum.notStarted: return "Not started";
    case TaskStatusEnum.started: return "Started";
    case TaskStatusEnum.inProgress: return "In Progress";
    case TaskStatusEnum.finished: return "Finished";
    case TaskStatusEnum.somethingIsWrong: return "Something is wrong";
  }
}

/// Класс задачи.
class Task {
  final TaskStatusEnum status;
  final String name;
  Task(this.name, [this.status = TaskStatusEnum.notStarted]);

  String get statusStr {
    return statusToString(status);
  }
}

/// Перечисление, которое хранит все состояния задачи.
enum TaskStatusEnum {notStarted, started, inProgress, finished, somethingIsWrong}

/// Хранит функции доступа к DataSource (источнику данных) что бы не захламлять основной (SimplePresentator) класс.
class Proxy{
  /// Здесь хранятся все задачи, полученные из _ds._list.
  final DataSource _ds;
  final SharedPreferences _data;

  @deprecated
  int counter = 0; // Это временная переменная, которая нужна что бы проверить работу библиотеки.
  @deprecated
  String taskString = ' '; // Это временная переменная, которая нужна что бы проверить работу библиотеки.
  @deprecated
  List<String> taskStringList = []; // Это временная переменная, которая нужна что бы проверить работу библиотеки.

  /// Конструктор этого класса. Его экземпляр хранит все задачи, полученные из _ds._list.
  Proxy(this._ds, this._data){
    counter = _data.getInt('counter') ?? 0;
    taskString = _data.getString('task string') ?? '';
    taskStringList = _data.getStringList('task string list') ?? []; // ToDo добавить использование в следующей версии.
  }

  /// Увеличивает счётчик и сохраняет в базу. Временная функция.
  @deprecated
  _increment(Task task) async{
    counter++;
    taskString = taskString + ", " + task.name;
    taskStringList.add(task.name);
    print(taskStringList);
    print("имя добавлемой таски ${task.name}");
    await _data.setInt("counter", counter);
    await _data.setString('task string', taskString);
    await _data.setStringList('task string list', taskStringList);
    print ('таска ${task.name} добавлена');
  }

  /// Получает актуальный список задач.
  Future<List<Task>> loadAll() async{
    try {
      final result = await _ds.readAll();
      print("finished loadAll");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return <Task>[];
    }
  }
  /// Создаёт задачу.
  Future<List<Task>> create(Task task) async {
    try {
      await _ds.create(task);
      _increment(task);
      print("таска ${task.name} совершенно точно добавлена");
      final result = await _ds.readAll();
      print("finished create");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return  <Task>[];
    }
  }
  /// Редактирует задачу.
  Future<List<Task>> edit(Task oldTask, Task newTask) async {
    try {
      await _ds.edit(oldTask, newTask);
      final result = await _ds.readAll();
      print("finished edit");
      return result;
    } catch (e, st) {
      print("$e, $st");
      final temp = Task("error in edit");
      return [temp];
    }
  }
  /// Удаляет задачу.
  Future<List<Task>> delete(List<int> indexes) async {
    try {
      await _ds.delete(indexes);
      final result = await _ds.readAll();
      print("finished delete");
      return result;
    } catch (e, st) {
      print("$e, $st, delete failed");
      return <Task>[];
    }
  }
}

/// Класс источника данных. Его экземпляр хранит список весх существующих задач.
class DataSource{
  /// Здесь хранятся все записи.
  final _list = <Task>[];
  /// Создаёт задачу.
  Future<void> create(Task task) async {
    await Future.delayed(Duration(milliseconds: 50));
    _list.add(task);
  }
  /// Редактирует задачу.
  Future<List<Task>> edit(Task oldTask, Task newTask) async {
    await Future.delayed(Duration(milliseconds: 50));
    int _i = _list.indexOf(oldTask);
    _list[_i] = newTask;
    return _list;
  }
  /// Удаляет задачу.
  Future<List<Task>> delete(List<int> indexes) async {
    await Future.delayed(Duration(milliseconds: 30));
    indexes.sort();
    for (; indexes.length > 0 ;){
      print(indexes[indexes.length-1]);
      int _i = indexes[indexes.length-1];
      print (_list[_i].name);
      _list.removeAt(indexes[indexes.length-1]);
      indexes.removeAt(indexes.length-1);
      print(_list);
      print(indexes);
    }
    return _list;
  }
  /// Выдаёт актуальный список задач.
  Future<List<Task>> readAll() async {
    await Future.delayed(Duration(milliseconds: 50));
    return _list;
  }
}
