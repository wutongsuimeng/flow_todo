import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flow_todo/dao/todoDao.dart';
import 'package:flow_todo/route.dart';
import 'package:flow_todo/todoEntity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class TomatoPage extends StatefulWidget {
  const TomatoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TomatoPageState();
}

class _TomatoPageState extends State<TomatoPage> {
  //可选择的任务
  List<Todo> todoItems = [Todo("")];

  //可选择的时间
  List<int> timeItems = [5];

  // 选择的时间
  int selectedTime = 5;

  //选择的任务
  List<Todo> selectedTodos = [Todo("")];

  @override
  void initState() {
    initData();
    //here is the async code, you can execute any async code here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text("选择执行任务："),
                      MultiSelectDialogField(
                        items: todoItems.map((e) => MultiSelectItem(e, e.content)).toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          print(values);
                          selectedTodos=values as List<Todo>;
                          print(selectedTodos);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("开始时间："),
                      DropdownButton<int>(
                          value: timeItems[0],
                          items:
                              timeItems.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("$value 分钟"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTime = value as int;
                            });
                          })
                    ],
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        //todo 启动按钮美化
                          child: Text("启动"),
                          textTheme: ButtonTextTheme.normal,
                          onPressed: () {
                            Navigator.push(
                                context,
                                PopRoute(
                                    child: _TomatoDoPageStateWidget(
                                        todos:
                                            selectedTodos,
                                        time: selectedTime)));
                          })
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initData() async {
    List<Todo> todoItemsTmp = [];
    List<int> timeItemsTmp = [];
    print("1");
    await TodoDao().rawQuery().then((value) => {
          todoItemsTmp = value,
          for (int i = 5; i <= 90; i += 5)
            {
              timeItemsTmp.add(i),
            },
    print("2"),
    todoItems = todoItemsTmp,
          setState(() {
            timeItems = timeItemsTmp;
            todoItems = todoItemsTmp;
            print(todoItems);
            print(timeItems);
          }),
        });
    print("3");
  }
}

class _TomatoDoPageStateWidget extends StatefulWidget {
  //选择的任务
  late List<Todo> todos;

  //选择的时间
  int time = 5;

  _TomatoDoPageStateWidget({required this.todos, required this.time});

  @override
  State<StatefulWidget> createState() {
    return _TomatoDoPageState(todos, time);
  }
}

class _TomatoDoPageState extends State<_TomatoDoPageStateWidget> {
  ///声明变量
  late Timer _timer;

  ///记录当前的时间
  late int time;
  List<Todo> todos;
  int totalTime;

  _TomatoDoPageState(this.todos, this.totalTime);

  @override
  void initState() {
    super.initState();
    time = totalTime * 60;

    ///循环执行
    ///间隔1秒
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time--;
      });

      ///到5秒后停止
      if (time <= 0) {
        _timer.cancel();
        completeTodo(todos);
      }
    });
    print("test"+todos.toString());
  }

  @override
  void dispose() {
    ///取消计时器
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("倒计时"),
      ),
      backgroundColor: Colors.white,

      ///填充布局
      body: Container(
          padding: EdgeInsets.all(100),
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            children: [
              ///层叠布局将进度与文字叠在一起
              Stack(
                ///子Widget居中
                alignment: Alignment.center,
                children: [
                  ///圆形进度
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      ///当前指示的进度
                      value: time / (totalTime * 60),
                      strokeWidth: 4,
                    ),
                  ),

                  ///显示的文本
                  Text(
                    "${time ~/ 60}:${(time % 60).toInt()}",
                    style: TextStyle(
                      fontSize: 70,
                    ),
                  ),
                ],
              ),
              Text("正在执行的任务：${todos.map((e) => e.content).join("、")}"),
            ],
          )),
    );
  }

  void completeTodo(List<Todo> todos) {
    TodoDao todoDao=TodoDao();
    for (var t in todos) {
      todoDao.query(t.id as int).then((todo) => {
        todo.finish=true,
        todoDao.update(todo)
      });
    }
  }
}
