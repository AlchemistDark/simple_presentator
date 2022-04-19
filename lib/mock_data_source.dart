import 'package:simple_presentator/simple_presentator.dart';

class MockDataSource implements IDataSource {
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