import 'dart:async';

/// Класс представления данных.
class SimplePresentator{
  /// Поля интерфейса класса.
  late TasksViewModel lastState;                     // Объект, с которым работает stream.
  Stream<TasksViewModel> get states => _ctrl.stream; // Создаём stream.

  /// Приватные поля класса.
  StreamController<TasksViewModel> _ctrl = StreamController<TasksViewModel>.broadcast(); // Создаём контроллер этого stream.
  late Proxy _px;                                    // Здесь хранятся все записи, полученные из _px._list.
  final DataSource _ds;                              // Ссылка на DataSource.

  /// Конструктор класса.
  SimplePresentator(this._ds){
    _px = Proxy(_ds);
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
  /// Помечает задачу/снимает пометку с задачи.
  Future<void> checkChange(Task task) async {
    final List<Task> updatedList = await _px.checkUncheck(task);
    _fireEvent(updatedList);
  }
  /// Удаляет задачу.
  Future<void> delete(Task task) async {
    final List<Task> updatedList = await _px.delete(task);
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
  final bool isDone;
  final TaskStatusEnum status;
  final String name;
  Task(this.name, [this.isDone = false, this.status = TaskStatusEnum.notStarted]);

  String get statusStr {
    return statusToString(status);
  }
}

enum TaskStatusEnum {notStarted, started, inProgress, finished, somethingIsWrong}

/// Хранит функции доступа к DataSource (источнику данных) что бы не захламлять основной (SimplePresentator) класс.
class Proxy{
  final DataSource _ds;      // Здесь хранятся все задачи, полученные из _ds._list.

  Proxy(this._ds);           // Конструктор этого класса. Его экземпляр хранит все задачи, полученные из _ds._list.

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
  /// Помечает задачу/снимает пометку с задачи.
  Future<List<Task>> checkUncheck(Task task) async {
    try {
      await _ds.checkUncheck(task);
      final result = await _ds.readAll();
      print("finished edit");
      return result;
    } catch (e, st) {
      print("$e, $st");
      final temp = Task("error in checker");
      return [temp];
    }
  }
  /// Удаляет задачу.
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

/// Класс источника данных. Его экземпляр хранит список весх существующих задач.
class DataSource{
  final _list = <Task>[]; // Здесь хранятся все записи.
  /// Создаёт задачу.
  Future<void> create(Task task) async {
    await Future.delayed(Duration(milliseconds: 50));
    _list.add(task);
    //return _list;
  }
  /// Редактирует задачу.
  Future<List<Task>> edit(Task oldTask, Task newTask) async {
    await Future.delayed(Duration(milliseconds: 50));
    int _i = _list.indexOf(oldTask);
    _list[_i] = newTask;
    return _list;
  }
  /// Помечает задачу/снимает пометку с задачи.
  Future<List<Task>> checkUncheck(Task task) async {
    await Future.delayed(Duration(milliseconds: 50));
    int _i = _list.indexOf(task);
    final newTask = Task(task.name, !task.isDone);
    _list[_i] = newTask;
    return _list;
  }
  /// Удаляет задачу.
  Future<List<Task>> delete(Task task) async {
    await Future.delayed(Duration(milliseconds: 30));
    _list.remove(task);
    return _list;
  }
  /// Выдаёт актуальный список задач.
  Future<List<Task>> readAll() async {
    await Future.delayed(Duration(milliseconds: 50));
    return _list;
  }
}

