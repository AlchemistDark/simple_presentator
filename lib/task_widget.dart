import 'package:flutter/material.dart';
import 'package:simple_presentator/task.dart';

/// Класс виджета задачи.
class TaskWidget extends StatelessWidget {
  /// Сюда передаётся выводимая виджетом задача.
  final Task task;
  /// Сюда передаётся выделенная это строка или нет.
  final bool isSelected;
  /// Сюда передаётся функция, выделяющая задачу.
  final void Function() onSelected;

  /// Конструктор класса.
  const TaskWidget({
    Key? key,
    required this.task,
    required this.isSelected,
    required this.onSelected,
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
        Container(
          padding: EdgeInsets.all(5),
          child: Text(
            task.statusStr,
          )
        ),
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(0),
          child: GestureDetector(
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






