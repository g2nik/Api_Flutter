import 'package:api_flutter/src/models/tasks_model.dart';
import 'package:api_flutter/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class TaskApiProvider {

  //Gets al tasks from the API
  Future<List<Task>> getAllTasks() async {
    var url = "https://5fdf8ffbeca1780017a30da3.mockapi.io/todos";
    Response response = await Dio().get(url);
    return (response.data as List).map((task) {
      print('Inserting $task');
      DBProvider.db.createTask(Task.fromJson(task));
    }).toList();
  }
}
