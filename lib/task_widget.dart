import 'package:flutter/material.dart';
import 'package:simple_presentator/simple_presentator.dart';

/// Класс виджета задачи.
class TaskWidget extends StatelessWidget {
  /// Сюда передаётся выводимая виджетом задача.
  final Task task;
  /// Сюда передаётся выделенная это строка или нет.
  final bool isSelected;
  /// Сюда передаётся функция, выделяющая задачу.
  final void Function() onSelected;
  /// Сюда передаётся функция, помечающая задачу.
  final void Function(bool?) onIsDoneChanged;

  /// Конструктор класса.
  const TaskWidget({
    Key? key,
    required this.task,
    required this.isSelected,
    required this.onSelected,
    required this.onIsDoneChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Color(0);
    if (isSelected) {
      color = Colors.green;
    } else {
      color = Colors.white;
    }
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Checkbox(
          value: task.isDone,
          onChanged: onIsDoneChanged,
        ),
        Text(task.statusStr),
        Expanded(child:
          GestureDetector(
            onTap: onSelected,
            child: Text(task.name,
              style: TextStyle(backgroundColor: color),
            )
          )
        ),
      ],
    );
  }
}






