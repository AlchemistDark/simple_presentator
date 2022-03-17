import 'dart:async';

/// Класс представления данных.
class SimplePresentator{
  late TasksViewModel lastState;                     // Тот самый объект.
  Stream<TasksViewModel> get states => _ctrl.stream; // Создаём stream.


  StreamController<TasksViewModel> _ctrl = StreamController<TasksViewModel>.broadcast(); // Создаём контроллер этого stream.
  late Proxy _px;              // Здесь хранятся все записи, полученные из _px._list.
  final DataSource _ds;        // Ссылка на DataSource.

  /// Конструктор класса.
  SimplePresentator(this._ds){
    loadAll();
    _px = Proxy(_ds);
    lastState = TasksViewModel([]);
  }
  /// Обновляет последнее событие потока.
  void _fireEvent(List<Task> updatedList) {
    lastState = TasksViewModel(updatedList.toList());
    _ctrl.add(lastState);
  }
  /// Получает все записи.
  Future<void> loadAll() async {
    final List<Task> updatedList =  await _px.loadAll();
    _fireEvent(updatedList);
  }
  /// Создаёт запись.
  Future<void> create(Task task) async {
    final List<Task> updatedList = await _px.create(task);
    _fireEvent(updatedList);
  }
  /// Редактирует запись.
  Future<void> edit(Task oldTask, Task newTask) async {
    final List<Task> updatedList = await _px.edit(oldTask, newTask);
    _fireEvent(updatedList);
  }
  /// Удаляет запись.
  Future<void> delete(Task task) async {
    final List<Task> updatedList = await _px.delete(task);
    _fireEvent(updatedList);
  }

  /// Закрыть stream.
  void discard(){
    _ctrl.close();
  }
}

class TasksViewModel {
  final List<Task> items;
  TasksViewModel(this.items);
}

class Task {
  final bool isDone;
  final String name;
  Task(this.name, [this.isDone = false]);
}

/// Хранит функции доступа к DataSource что бы не захламлять основной (SimplePresentator) класс.
class Proxy{
  final DataSource _ds;

  Proxy(this._ds); // Здесь хранятся все записи, получfенные из _ds._list.

  /// Получает все записи.
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
  /// Создаёт запись.
  Future<List<Task>> create(Task task) async {
    try {
      await _ds.create(task);
      final result = await _ds.readAll();
      print("finished create");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return  <Task>[];
    }
  }
  /// Редактирует запись.
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
  /// Удаляет запись.
  Future<List<Task>> delete(Task task) async {
    try {
      await _ds.delete(task);
      final result = await _ds.readAll();
      print("finished delete");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return <Task>[];
    }
  }
}

/// Хранит записи.
class DataSource{
  final _list = <Task>[]; // Здесь хранятся все записи.
  /// Создаёт запись.
  Future<void> create(Task task) async {
    await Future.delayed(Duration(milliseconds: 50));
    _list.add(task);
    //return _list;
  }
  /// Редактирует запись.
  Future<List<Task>> edit(Task oldTask, Task newTask) async {
    await Future.delayed(Duration(milliseconds: 50));
    int _i = _list.indexOf(oldTask);
    _list[_i] = newTask;
    return _list;
  }
  /// Удаляет запись.
  Future<List<Task>> delete(Task task) async {
    await Future.delayed(Duration(milliseconds: 30));
    _list.remove(task);
    return _list;
  }
  /// Выдаёт весь список записей.
  Future<List<Task>> readAll() async {
    await Future.delayed(Duration(milliseconds: 50));
    return _list;
  }
}

