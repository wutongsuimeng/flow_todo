import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtil{
  String path="";
  Database getConnection(){
    Database database=openDatabase(path) as Database;
    return database;
  }

  Future testDatabase() async{
    String path=join(await getDatabasesPath(),"flow_todo.db");
    print(path);
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        });
  }
}
