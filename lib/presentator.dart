import 'dart:async';                             // Класс для асинхронной работы.
import 'package:simple_presentator/task.dart';   // Класс задачи.

/// Класс представления данных.
class Presentator{
  /// Поля интерфейса класса.
  // Объект, с которым работает stream.
  late TasksViewModel lastState;
  // Создаём stream.
  Stream<TasksViewModel> get states => _ctrl.stream;

  /// Приватные поля класса.
  // Создаём контроллер этого stream.
  StreamController<TasksViewModel> _ctrl = StreamController<TasksViewModel>.broadcast();
  // Здесь хранятся все записи, полученные из _px._list.
  late _Proxy _px;
  // Ссылка на DataSource.
  final IDataSource _ds;

  /// Конструктор класса.
  Presentator(this._ds) {
    _px = _Proxy(_ds);
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

/// Хранит функции доступа к DataSource (источнику данных) что бы не захламлять основной (SimplePresentator) класс.
class _Proxy{
  /// Здесь хранятся все задачи, полученные из _ds._list.
  final IDataSource _ds;

  /// Конструктор этого класса. Его экземпляр хранит все задачи, полученные из _ds._list.
  _Proxy(this._ds);

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
      final result = await _ds.readAll();
      print("finished create");
      return result;
    } catch (e) {
      rethrow;
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

/// Класс, преобразующий задачу для вывода (например, в консоль или в специальный виджет).
class TasksViewModel {
  final List<Task> items;
  TasksViewModel(this.items);
}

/// Класс источника данных. Его экземпляр хранит список весх существующих задач.
abstract class IDataSource {
  /// Создаёт задачу.
  Future<void> create(Task task);

  /// Редактирует задачу.
  Future<List<Task>> edit(Task oldTask, Task newTask);

  /// Удаляет задачу.
  Future<List<Task>> delete(List<int> indexes);

  /// Выдаёт актуальный список задач.
  Future<List<Task>> readAll();
}

