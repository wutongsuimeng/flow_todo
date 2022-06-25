import 'package:flow_todo/database.dart';
import 'package:flow_todo/todoEntity.dart';
import 'package:sqflite/sqflite.dart';

class TodoDao{

  Future<List<Todo>> rawQuery() async {
    Database database=await DatabaseUtil.getConnection();
    List<Map> maps = await database.rawQuery("SELECT * FROM Todo");
    return List.generate(maps.length, (index){
      //todo finish
      Todo todo=Todo(maps[index]['content']);
      todo.id=maps[index]['id'];
      todo.finish=maps[index]['finish']==1?true:false;
      return todo;
    });
  }

  Future<int> insert(Todo todo) async{
    Database database=await DatabaseUtil.getConnection();
    return database.insert("Todo", todo.toMap());
  }

  Future<int> delete(int id) async{
    Database database=await DatabaseUtil.getConnection();
    return database.rawDelete("delete from Todo where id=?",[id]);
  }

  Future<int> update(Todo todo) async{
    Database database=await DatabaseUtil.getConnection();
    int finish=todo.finish?1:0;
    return database.rawUpdate("update Todo set content=?,finish=? where id=?",[todo.content,finish,todo.id]);
  }
}