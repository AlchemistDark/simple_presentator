import 'package:flutter/material.dart';

class StringWidget extends StatelessWidget {
  final bool isEditable;                          // Сюда передаётся редактируемая это строка или нет.
  final String str;                               // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final callBackChecked;                          // Сюда передаётся функция, помечающая строку как редактируемую.
  final callBackEdit;                             // Сюда передаётся функция редактирования строки.
  final callBackDelete;                           // Сюда передаётся функция удаления строки.

  const StringWidget(
    {Key? key, required this.isEditable, required this.str, required this.callBackChecked, required this.callBackEdit, required this.callBackDelete}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditable) {
      return
        TextField(
          onSubmitted: callBackEdit,
          decoration: InputDecoration(border: OutlineInputBorder(), hintText: str)
        );
    }
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        ElevatedButton.icon(
          onPressed: callBackChecked,
          style: ElevatedButton.styleFrom(primary: Colors.green, fixedSize: Size(5, 5)),
          icon: Icon(Icons.edit),
          label: Text("")
        ),
        ElevatedButton.icon(
          onPressed: callBackDelete,
          style: ElevatedButton.styleFrom(primary: Colors.red, fixedSize: Size(20, 20)),
          icon: Icon(Icons.remove),
          label: Text("")
        ),
        Text(str),
      ],
    );
  }
}






