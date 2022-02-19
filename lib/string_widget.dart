import 'package:flutter/material.dart';


class StringWidget extends StatefulWidget{
  final int editedIndex;     // Сюда передаётся индекс той строки, которая сейчас редактируется.
  final int stringIndex;     // Сюда передаётся индекс той строки, которую отображает виджет.
  final String str;          // Сюда передаётся та строка списка, ради которой и замутили виджет.
  final callBackDelete;      // Сюда передаётся функция удаления строки.

  const StringWidget({Key? key, required this.editedIndex, required this.stringIndex, required this.str,
    required this.callBackDelete}) : super(key: key);
  @override
  _StringWidgetState createState() => _StringWidgetState(editedIndex, stringIndex, str);
}

class _StringWidgetState extends State<StringWidget> {
  final int editedIndex;
  final int stringIndex;
  final String str;

  _StringWidgetState(this.editedIndex, this.stringIndex, this.str);

  @override
  Widget build(BuildContext context) {

    if (editedIndex == stringIndex) {
      return
        TextField(
            onSubmitted: (newStr) async {
              //await present.edit(str, newStr);  // Метод класса из строки 4 для изменения строки списка.
              //editedIndex = -1;                 // Отметить, что строка больше не редактируется.
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: str,
            )
        );
    }
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        ElevatedButton.icon(
            onPressed: () async {
              //editedIndex = stringIndex;            // Пометить строку как редактируемую.
              //await present.loadAll(); // Это событие нужно чтобы обновить экран.
            },
            style: ElevatedButton.styleFrom(primary: Colors.green, fixedSize: Size(5, 5)),
            icon: Icon(Icons.edit),
            label: Text("")
        ),
        ElevatedButton.icon(
            onPressed: widget.callBackDelete,
            style: ElevatedButton.styleFrom(primary: Colors.red, fixedSize: Size(20, 20)),
            icon: Icon(Icons.remove),
            label: Text("")
        ),
        Text(str),
      ],
    );
  }
}


