import 'package:flow_todo/database.dart';
import 'package:flow_todo/todoEntity.dart';
import 'package:sqflite/sqflite.dart';

class TodoDao{
  Database database=DatabaseUtil.getConnection() as Database;

  Future<List<Todo>> rawQuery() async {
    List<Map> maps = await database.rawQuery("SELECT * FROM Todo");
    return List.generate(maps.length, (index){
      //todo finish
      return Todo(maps[index]['content']);
    });
  }

  Future<int> insert(Todo todo){
    return database.insert("Todo", todo.toMap());
  }
}