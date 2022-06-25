
import 'dart:ui';

import 'package:flutter/material.dart';

class Todo{
  int? id;
  String content;
  Decoration decoration=Decoration();
  //是否完成
  bool finish=false;

  //todo
  Todo(this.content,{this.finish=false});


  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['finish'] = finish?1:0;
    return data;
  }

   Todo toTodo(Map<String, dynamic> json) {
    content = json['content'];
    finish = json['finish'];
    return this;
  }
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