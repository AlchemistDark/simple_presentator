import 'package:flutter/material.dart';
import 'package:simple_presentator/task.dart';

class TaskEditDialog extends StatefulWidget{

  /// Задача, которую получает виджет.
  final Task task;

  /// Конструктор класса.
  TaskEditDialog({Key? key, required this.task}) : super(key: key);

  @override
  _TaskEditDialogState createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  /// Задача, которую возвращает виджет.
  Task _editedTask = Task("If you see it, then something is wrong.");

  /// Изменение имени задачи.
  void _onTextSubmitted(String text){
    Task tempTask = Task(text);
    _editedTask = tempTask;
  }

  /// Изменение имени задачи.
  void _onDropdownButtonChanged (TaskStatusEnum newValue){
    setState(() {
      Task tempTask = Task(widget.task.name, newValue);
      _editedTask = tempTask;
    });
  }

  /// Возврат из виджета на главное окно.
  void _onApplyPressed(BuildContext context) {
    Navigator.of(context).pop<Task>(_editedTask);   // Сюда передаётся итоговый таск
  }

  @override
  void initState() {
    super.initState();
    _editedTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: ()=>_onApplyPressed(context), // Apply
            child: Icon(Icons.check)
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name", style: theme.textTheme.headline4,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(initialValue: _editedTask.name,
              onChanged: (newText)=>_onTextSubmitted(newText),
              onFieldSubmitted: (newText)=>_onTextSubmitted(newText),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a new task name",
              ),
            ),
          ),
          Text("Status", style: theme.textTheme.headline4,),
          buildDropdownButton()
        ],
      ),
    );
  }

  DropdownButton<TaskStatusEnum> buildDropdownButton() {
    final items = TaskStatusEnum.values;
    final menuItems = items.map<DropdownMenuItem<TaskStatusEnum>>((e) {
      return DropdownMenuItem<TaskStatusEnum>(
        value: e,
        child: Text(statusToString(e)),
      );
    }).toList();
    return DropdownButton<TaskStatusEnum>(
      items: menuItems,
      value: _editedTask.status,
      onChanged: (TaskStatusEnum? newValue) {
        print(newValue);
        _onDropdownButtonChanged(newValue!);
      },
    );
  }
}