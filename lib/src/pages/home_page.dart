import 'package:api_flutter/src/providers/db_provider.dart';
import 'package:api_flutter/src/providers/todos_api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Tareas'),
        actions: <Widget>[
          
          //Load data from the API to the database
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async => await _loadFromApi(),
            ),
          ),

          //Clear the data from the database
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async => await _deleteData(),
            ),
          ),
        ],
      ),
      body: isLoading ? Center( child: CircularProgressIndicator()) : _buildTaskListView(),
    );
  }

  //Get all tasks from the table and wait 2 secs
  _loadFromApi() async {
    setState(() => isLoading = true);
    var apiProvider = TaskApiProvider();
    await apiProvider.getAllTasks();
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
  }

  //Delete all the table and wait 1 sec
  _deleteData() async {
    setState(() => isLoading = true);
    await DBProvider.db.deleteAllTasks();
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  //Show a loading indicator if data is not loaded return a circle
  //else return the data from the table
  _buildTaskListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllTasks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center( child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            itemCount: snapshot.data.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(snapshot.data[index].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(snapshot.data[index].description, style: TextStyle(color: Colors.white)),
              );
            },
          );
        }
      },
    );
  }
}
