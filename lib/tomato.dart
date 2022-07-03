import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flow_todo/dao/todoDao.dart';
import 'package:flow_todo/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

class TomatoPage extends StatefulWidget {
  const TomatoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TomatoPageState();
}

//已选择的任务
List<int> picks = [];
int selectTime = 5;

class _TomatoPageState extends State<TomatoPage> {
  //选择的任务
  List<PickerItem<int>> todos = [];

  //选择的时间
  List<int> time = [];

  @override
  void initState() {
    super.initState();
    List<PickerItem<int>> tmp = [];
    List<int> tmpTime = [];
    TodoDao().rawQuery().then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              tmp.add(
                  PickerItem(text: Text(value[i].content), value: value[i].id))
            },
          setState(() {
            todos = tmp;
          }),
        });
    for (int i = 5; i <= 90; i += 5) {
      tmpTime.add(i);
    }
    setState(() {
      time = tmpTime;
      print(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text("执行任务："),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    Picker(
                        adapter: PickerDataAdapter<int>(data: todos),
                        hideHeader: true,
                        title: new Text("选择执行的任务"),
                        onConfirm: (Picker picker, List value) {
                          // print(value.toString());
                          // print(picker.getSelectedValues());
                          picks.clear();
                          for (var value1 in picker.getSelectedValues()) {
                            picks.add(value1);
                          }
                          print(picks);
                        }).showDialog(context);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("开始时间："),
                MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    Picker(
                        adapter: PickerDataAdapter<int>(pickerdata: time),
                        hideHeader: true,
                        title: new Text("选择执行的时间(分钟)"),
                        onConfirm: (Picker picker, List value) {
                          // print(value.toString());
                          // print(picker.getSelectedValues());
                          selectTime = picker.getSelectedValues()[0];
                          print(selectTime);
                        }).showDialog(context);
                  },
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                    child: Text("启动"),
                    textTheme: ButtonTextTheme.normal,
                    onPressed: () {
                      print("启动");
                      Navigator.push(
                          context,
                          PopRoute(
                              child: _TomatoDoPageStateWidget(
                                  todos: picks, time: selectTime)));
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TomatoDoPageStateWidget extends StatefulWidget {
  //选择的任务
  List<int> todos = [];

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
  List<int> todos;
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
      }
    });
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
                  Container(
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
              )
            ],
          )),
    );
  }
}
