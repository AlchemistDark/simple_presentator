import 'package:flutter/material.dart';

/// Класс виджета задачи.
class TaskWidget extends StatelessWidget {
  final bool isSelected;                             // Сюда передаётся помечена задача или нет.
  final bool isEditMode;                             // Сюда передаётся редактируемая это строка или нет.
  final String str;                                  // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final void Function() onSelected;                  // Сюда передаётся функция, выделяющая задачу.
  final void Function(bool?) onCheckChanged;         // Сюда передаётся функция, помечающая задачу.
  final void Function(String text) onEditFinished;   // Сюда передаётся функция редактирования строки.

  /// Конструктор класса.
  const TaskWidget({
    Key? key,
    required this.isSelected,
    required this.isEditMode,
    required this.str,
    required this.onSelected,
    required this.onCheckChanged,
    required this.onEditFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      return
        TextField(
          onSubmitted: onEditFinished,
          decoration: InputDecoration(border: OutlineInputBorder(), hintText: str)
        );
    }
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Checkbox(
          value: isSelected,
          onChanged: onCheckChanged,
        ),
        Expanded(child:
          GestureDetector(
            onTap: onSelected,
            child: Text(str)
          )
        ),
      ],
    );
  }
}






