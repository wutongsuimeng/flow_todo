
import 'dart:ui';

import 'package:flutter/material.dart';

class Todo{
  String title;
  String content;
  Decoration decoration=Decoration();
  //是否完成
  bool finish=false;

  Todo(this.title, this.content);
}

//todo效果
class Decoration{
  //文字效果
  TextStyle textStyle=TextStyle();
  //按钮 todo
  // final IconButton button;
  Icon icon=Icon(Icons.circle_outlined);
  //完成方法
  void finish(){
    textStyle=TextStyle(
      //删除线
      decoration: TextDecoration.lineThrough,
      color: Colors.grey,
    );
    icon=Icon(Icons.check_circle);
  }
}