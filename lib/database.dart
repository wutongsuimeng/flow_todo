import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtil{
  static Future<Database> getConnection() async{
    String path=join(await getDatabasesPath(),"flow_todo.db");
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Todo (id INTEGER PRIMARY KEY, content TEXT, finish INTEGER)');
        });
    return database;
  }
}
