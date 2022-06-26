import 'dart:convert';

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
                Text("执行任务:"),
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
                Text("开始时间:"),
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
                      Navigator.push(context,PopRoute(child: _TomatoDoPageStateWidget(
                        todos: picks,
                        time: selectTime,
                      )));
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TomatoDoPageStateWidget extends StatelessWidget{
  //选择的任务
  List<int> todos = [];

  //选择的时间
  int time =5;

  _TomatoDoPageStateWidget({required this.todos,required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("倒计时:"+todos.toString()+","+time.toString()),
      ),
    );
  }


}
