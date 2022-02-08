import 'dart:async';

/// Класс представления данных.
class SimplePresentator{
  final Proxy _px; // Здесь хранятся все записи, полученные из _px._list.
  Stream<List<String>> get data => _ctrl.stream; // Создаём stream.
  StreamController<List<String>> _ctrl = StreamController<List<String>>.broadcast(); // Создаём контроллер этого stream.
  List<String> lastEvent = []; // Я не помню что это и зачем, или не понимаю, но зачем-то тут пустой список...
  // Наверное это инициализация списка последних событий.

  /// Конструктор класса.
  SimplePresentator(this._px){
    loadAll();
  }
  ///
  void _fireEvent(List<String> updatedList) {
    final newEvent = updatedList.toList();
    lastEvent = newEvent;
    _ctrl.add(newEvent);
  }
  /// Получает все записи.
  Future<void> loadAll() async {
    final List<String> updatedList =  await _px.loadAll();
    _fireEvent(updatedList);
  }
  /// Создаёт запись.
  Future<void> create(String str) async {
    final List<String> updatedList = await _px.create(str);
    _fireEvent(updatedList);
  }
  /// Редактирует запись.
  Future<void> edit(String oldStr, String newStr) async {
    final List<String> updatedList = await _px.edit(oldStr, newStr);
    _fireEvent(updatedList);
  }
  /// Удаляет запись.
  Future<void> delete(String str) async {
    final List<String> updatedList = await _px.delete(str);
    _fireEvent(updatedList);
  }

  /// Закрыть stream.
  void discard(){
    _ctrl.close();
  }
}

/// Хранит функции доступа к DataSource что бы не захламлять основной (SimplePresentator) класс.
class Proxy{
  final DataSource _ds = DataSource(); // Здесь хранятся все записи, полученные из _ds._list.

  /// Получает все записи.
  Future<List<String>> loadAll() async{
    try {
      final result = await _ds.readAll();
      print("finished loadAll");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return <String>[];
    }
  }
  /// Создаёт запись.
  Future<List<String>> create(String str) async {
    try {
      await _ds.create(str);
      final result = await _ds.readAll();
      print("finished create");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return  <String>[];
    }
  }
  /// Редактирует запись.
  Future<List<String>> edit(String oldStr, String newStr) async {
    try {
      await _ds.edit(oldStr, newStr);
      final result = await _ds.readAll();
      print("finished edit");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return <String>["error in edit"];
    }
  }
  /// Удаляет запись.
  Future<List<String>> delete(String str) async {
    try {
      await _ds.delete(str);
      final result = await _ds.readAll();
      print("finished delete");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return <String>[];
    }
  }
}

/// Хранит записи.
class DataSource{
  final _list = <String>[]; // Здесь хранятся все записи.
  /// Создаёт запись.
  Future<void> create(String str) async {
    await Future.delayed(Duration(milliseconds: 50));
    _list.add(str);
    //return _list;
  }
  /// Редактирует запись.
  Future<List<String>> edit(String oldStr, String newStr) async {
    await Future.delayed(Duration(milliseconds: 50));
    int _i = _list.indexOf(oldStr);
    _list[_i] = newStr;
    return _list;
  }
  /// Удаляет запись.
  Future<List<String>> delete(String str) async {
    await Future.delayed(Duration(milliseconds: 30));
    _list.remove(str);
    return _list;
  }
  /// Выдаёт весь список записей.
  Future<List<String>> readAll() async {
    await Future.delayed(Duration(milliseconds: 50));
    return _list;
  }
}