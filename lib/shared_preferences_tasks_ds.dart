import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_presentator/simple_presentator.dart';
import 'dart:convert';


class SharedPreferencesTasksDataSource implements IDataSource {

  SharedPreferencesTasksDataSource(this._data);

  @override
  Future<List<Task>> readAll() async {
    final strList = _data.getStringList(_taskListId) ?? [];

    final loadedTasks = <Task>[];

    for (var str in strList) {
      final obj = (jsonDecode(str) as Map).cast<String, Object?>();
      final task = _taskFromJson(obj);
      loadedTasks.add(task);
    }

    _tasksCache.clear();
    _tasksCache.addAll(loadedTasks);

    return _tasksCache.toList(growable: false);
  }


  @override
  Future<void> create(Task newTask) async {
    _tasksCache.add(newTask);

    final strList = <String>[];

    for (var task in _tasksCache) {
      final map = _taskToJson(task);
      final str = jsonEncode(map);
      strList.add(str);
    }

    _data.setStringList(_taskListId, strList);
  }

  @override
  Future<List<Task>> delete(List<int> indexes) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> edit(Task oldTask, Task newTask) {
    // TODO: implement edit
    throw UnimplementedError();
  }


  Task _taskFromJson(Map<String, Object?> obj) {
    return Task(
      obj[_taskName] as String,
      _statusFromString(obj[_taskStatus] as String),
    );
  }

  Map<String, Object> _taskToJson(Task task) {
    return {
      _taskName: task.name,
      _taskStatus: _statusToString(task.status),
    };
  }

  /// Возвращает строку, соответсвующую статусу задачи.
  String _statusToString(TaskStatusEnum status) {
    switch (status){
      case TaskStatusEnum.notStarted: return _statusNotStarted;
      case TaskStatusEnum.started: return _statusStarted;
      case TaskStatusEnum.inProgress: return _statusInProgress;
      case TaskStatusEnum.finished: return _statusFinished;
      case TaskStatusEnum.somethingIsWrong: return _statusSmthIsWrong;
    }
  }

  /// Возвращает строку, соответсвующую статусу задачи.
  TaskStatusEnum _statusFromString(String status) {
    switch (status) {
      case _statusNotStarted: return TaskStatusEnum.notStarted;
      case _statusStarted: return TaskStatusEnum.started;
      case _statusInProgress: return TaskStatusEnum.inProgress;
      case _statusFinished: return TaskStatusEnum.finished;
      case _statusSmthIsWrong: return TaskStatusEnum.somethingIsWrong;
    }

    throw ArgumentError('Unknown status string: \"$status\"');
  }


  final SharedPreferences _data;
  final List <Task> _tasksCache = <Task>[];
}

const _taskListId = "taskListId";

const _taskName = "name";
const _taskStatus = "status";

const _statusNotStarted = "Not started";
const _statusStarted = "Started";
const _statusInProgress = "In Progress";
const _statusFinished = "Finished";
const _statusSmthIsWrong = "Something is wrong";