import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_presentator/data_source.dart';

/// Перечисление, которое хранит все состояния задачи.
enum TaskStatusEnum {notStarted, started, inProgress, finished, somethingIsWrong}

/// Класс задачи.
class Task {
  //late final int uid;
  late final String name;
  final TaskStatusEnum status;

  String get statusStr {return statusToString(status);}

  /// Конструктор.
  Task(this.name, [this.status = TaskStatusEnum.notStarted]) {
    //var dT = DateTime.now();                      // Генерирует уникальный ID
    //this.uid = dT.microsecondsSinceEpoch;      // как количество микросекунд с начала Эпохи Unix.
  }

  /// Конструктор для чтения из файла.
  Task.fromJSON(Map<String, dynamic> data, [this.status = TaskStatusEnum.notStarted]){
    this.name = data["name"] as String;
  }

  @override
  String toString() {
    return '{"name": $name, "status": ${statusToString(status)}}';
  }

  /// Для сохранения в файл.
  Map<String, dynamic> toJSON(){
    return {
      'name': name,
      'status': statusToString(status)
    };
  }
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

/// Класс, преобразующий задачу для вывода (например, в консоль или в специальный виджет).
class TasksViewModel {
  final List<Task> items;
  TasksViewModel(this.items);
}