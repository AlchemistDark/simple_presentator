/// Класс задачи.
class Task {
  final TaskStatusEnum status;
  final String name;
  Task(this.name, [
    this.status = TaskStatusEnum.notStarted]);

  String get statusStr {
    return statusToString(status);
  }
}

enum TaskStatusEnum {notStarted, started, inProgress, finished, somethingIsWrong}

String statusToString(TaskStatusEnum status) {
  switch (status){
    case TaskStatusEnum.notStarted: return "Not started";
    case TaskStatusEnum.started: return "Started";
    case TaskStatusEnum.inProgress: return "In Progress";
    case TaskStatusEnum.finished: return "Finished";
    case TaskStatusEnum.somethingIsWrong: return "Something is wrong";
  }
}