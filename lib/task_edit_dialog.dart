import 'package:flutter/material.dart';
import 'package:simple_presentator/simple_presentator.dart';

class TaskEditDialog extends StatelessWidget{
  final Task task;

  Task _editedTask = Task("");

  TaskEditDialog({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        children: [
          Text(task.name),
          TextField(
            onSubmitted: (newText)=>_onTextSubmitted(newText),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter a new task name",
            ),
          ),
        ],
      ),
    );
  }

  void _onTextSubmitted(String text){
    Task tempTask = Task(text);
    _editedTask = tempTask;
  }

  void _onApplyPressed(BuildContext context) {
    Navigator.of(context).pop<Task>(_editedTask);   // Сюда передаётся итоговый таск
  }
}