import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final bool isChecked;                           // Сюда передаётся помечена задача или нет.
  final bool isEditMode;                          // Сюда передаётся редактируемая это строка или нет.
  final String str;                               // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final void Function(bool?) checkUncheck;        // Сюда передаётся функция, помечающая задачу.
  final void Function() onSelected;               // Сюда передаётся функция, помечающая строку как редактируемую.
  final void Function(String text) onEdited;      // Сюда передаётся функция редактирования строки.
  final void Function() onDeleted;                // Сюда передаётся функция удаления строки.

  const TaskWidget({
    Key? key,
    required this.isChecked,
    required this.isEditMode,
    required this.str,
    required this.checkUncheck,
    required this.onSelected,
    required this.onEdited,
    required this.onDeleted
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      return
        TextField(
          onSubmitted: onEdited,
          decoration: InputDecoration(border: OutlineInputBorder(), hintText: str)
        );
    }
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: checkUncheck,
        ),
        ElevatedButton.icon(
          onPressed: onSelected,
          style: ElevatedButton.styleFrom(primary: Colors.green, fixedSize: Size(5, 5)),
          icon: Icon(Icons.edit),
          label: Text("")
        ),
        ElevatedButton.icon(
          onPressed: onDeleted,
          style: ElevatedButton.styleFrom(primary: Colors.red, fixedSize: Size(20, 20)),
          icon: Icon(Icons.remove),
          label: Text("")
        ),
        Text(str),
      ],
    );
  }
}






