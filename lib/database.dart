import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Database{
  String path="";
  Database getConnection(){
    Database database=openDatabase(path) as Database;
    return database;
  }

  void main(List<String> args) async{
    String path=join(await getDatabasesPath(),"/demo");
    print(path);
  }
}