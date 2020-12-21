import 'dart:convert';

List<Task> TaskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String TaskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//Each task only has an id, a title and a description
class Task {
  var id;
  String title;
  String description;

  Task({this.id, this.title, this.description});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
  };
}
