import 'package:flutter/material.dart';

class StringWidget extends StatelessWidget {
  final bool isEditMode;                          // Сюда передаётся редактируемая это строка или нет.
  final String str;                               // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final void Function() onSelected;          // Сюда передаётся функция, помечающая строку как редактируемую.
  final void Function(String text) onEdited;  // Сюда передаётся функция редактирования строки.
  final void Function() onDeleted;           // Сюда передаётся функция удаления строки.

  const StringWidget(
    {Key? key, required this.isEditMode, required this.str, required this.onSelected, required this.onEdited, required this.onDeleted}
  ) : super(key: key);

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






