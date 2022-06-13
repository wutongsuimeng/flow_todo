import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task/main.dart';
import 'package:task/route.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:task/todoEntity.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> list=[
    Todo("todo1", "todo1"),
    Todo("todo2", "todo2")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 80)),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: 番茄钟的按钮，弹窗，能指定对某项todo开始番茄钟
                  print("番茄钟");
                  Navigator.push(
                      context, PopRoute(child: _ProvideWidgetState()));
                },
                child: Icon(Icons.play_circle_fill),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, PopRoute(child: InputButtomWidget(
                    onEditingCompleteText: (text) {
                      setState(() {
                        list.add(Todo(text, text));
                      });
                    },
                  )));
                },
              ),
            )
          ],
        ),
        //列表
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              //手势监听
              return GestureDetector(
                child: Container(
                    //边框
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1)),
                      // borderRadius:BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    //将正常与删除页面堆叠在一起
                    child: Dismissible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Text(
                                list[index].content,
                              style: list[index].decoration.textStyle,
                            ),
                            padding: EdgeInsets.all(8),
                          ),
                          //完成
                          Container(
                            padding: EdgeInsets.all(8),
                            child: IconButton(
                              onPressed: () {
                                print(list[index].finish);
                                if(!list[index].finish){
                                  finishTodo(index);
                                  print("已完成");
                                }
                                print("按下按钮" + index.toString());
                              },
                              icon: list[index].decoration.icon,
                            ),
                          )
                        ],
                      ),
                      key: Key(list[index].content),
                      //右滑 todo
                      background: Container(
                        color: Colors.green,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          color: Colors.green,
                        ),
                      ),
                      //左滑
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                        ),
                      ),
                      //滑动触发事件
                      onDismissed: (DismissDirection direction){
                        //左到右
                        //todo 待做，重点/完成
                        if(direction==DismissDirection.startToEnd){
                          print("todo");
                        }
                        //右到左
                        else if(direction==DismissDirection.endToStart){
                          print("删除");
                          setState(() {
                            list.removeAt(index);
                          });
                        }
                      },
                      confirmDismiss: (DismissDirection direction) async{
                        await Future.delayed(Duration(seconds: 2));
                        print('_confirmDismiss:$direction');
                        return direction==DismissDirection.endToStart;
                      },
                    )
              ),
                //点击事件
                onTap: () {
                  //修改todo
                  if(!list[index].finish){
                    Navigator.push(context, PopRoute(child: ModifiedButtomWidget(
                        onEditingCompleteText: (text) {
                          setState(() {
                            list[index]=Todo(text, text);
                          });
                        },todo:list[index]
                    )));
                  };
                  main();
                },
                //长按事件
                onLongPress: () {
                  print("长按事件");
                },
                // //准备开始滑动
                // onHorizontalDragDown: (DragDownDetails details) {
                //   print("准备开始滑动");
                // },
                // //水平方向上滑动时回调，随着手势滑动一直回调。
                // onHorizontalDragUpdate: (DragUpdateDetails updateDetails) {
                //   print("正在滑动");
                // },
                // //水平方向上滑动结束时回调
                // onHorizontalDragEnd: (DragEndDetails endDetails) {
                //   print("结束滑动");
                // },
              );
            }));
  }

  //完成事件
  void finishTodo(int index){
    setState((){
      list[index].finish=true;
      //改变样式
      list[index].decoration.finish();
    });
  }
}

// 新建任务组件
class InputButtomWidget extends StatelessWidget {
  final ValueChanged onEditingCompleteText;
  final TextEditingController controller = TextEditingController();

  InputButtomWidget({required this.onEditingCompleteText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: new Column(
        children: <Widget>[
          Expanded(
              child: new GestureDetector(
            child: new Container(
              color: Colors.transparent,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          new Container(
              color: Color(0xFFF4F4F4),
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
              child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: controller,
                              autofocus: true,
                              style: TextStyle(fontSize: 16),
                              //设置键盘按钮为发送
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.multiline,
                              onEditingComplete: () {
                                //点击发送调用
                                print('onEditingComplete');
                                onEditingCompleteText(controller.text);
                                Navigator.pop(context);
                              },
                              decoration: InputDecoration(
                                hintText: '请输入待办事项',
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5, right: 10),
                                border: const OutlineInputBorder(
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),

                              minLines: 1,
                              maxLines: 5,
                            ),
                          ),
                          Container(
                            child: MaterialButton(
                              child: Text("发送",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue)),
                              onPressed: () {
                                onEditingCompleteText(controller.text);
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}

//修改任务
class ModifiedButtomWidget extends StatelessWidget {
  final ValueChanged onEditingCompleteText;
  final TextEditingController controller = TextEditingController();
  Todo todo;

  ModifiedButtomWidget({required this.onEditingCompleteText,required this.todo});

  @override
  Widget build(BuildContext context) {
    controller.text=this.todo.content;
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Column(
        children: <Widget>[
          Expanded(
              child: new GestureDetector(
                child: new Container(
                  color: Colors.transparent,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          new Container(
              color: Color(0xFFF4F4F4),
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
              child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: controller,
                              autofocus: true,
                              style: TextStyle(fontSize: 16),
                              //设置键盘按钮为发送
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.multiline,
                              onEditingComplete: () {
                                //点击发送调用
                                print('onEditingComplete');
                                onEditingCompleteText(controller.text);
                                Navigator.pop(context);
                              },
                              decoration: InputDecoration(
                                hintText: '请输入待办事项',
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5, right: 10),
                                border: const OutlineInputBorder(
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),

                              minLines: 1,
                              maxLines: 5,
                            ),
                          ),
                          Container(
                            child: MaterialButton(
                              child: Text("发送",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue)),
                              onPressed: () {
                                onEditingCompleteText(controller.text);
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}

//番茄钟组件
class _ProvideWidgetState extends StatelessWidget {
  TextEditingController _decController = TextEditingController();

  static const PickerData2 = '''
[
    [
        1,
        2,
        3,
        4
    ],
    [
        11,
        22,
        33,
        44
    ],
    [
        "aaa",
        "bbb",
        "ccc"
    ]
]
    ''';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '报价：',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF333333),
                                    decoration: TextDecoration.none),
                              ),
                              Expanded(
                                child: Container(
                                  height: 30.0,
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)), //边角为5
                                  ),
                                  child: TextField(
                                    controller: _decController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        /*边角*/
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5), //边角为5
                                        ),
                                        borderSide: BorderSide(
                                          color: Color(0XFFEEEEEE), //边线颜色为白色
                                          width: 1, //边线宽度为2
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0XFFEEEEEE), //边框颜色为白色
                                          width: 1, //宽度为5
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5), //边角为30
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(0),
                                      hintStyle: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '万元',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF333333),
                                    decoration: TextDecoration.none),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0XFFEEEEEE)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Text(
                                  '面议',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0XFF333333),
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 23),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '车辆信息描述',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0XFF333333),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFEEEEEE), width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            child: TextField(
                                maxLines: 4,
                                maxLength: 100,
                                textInputAction: TextInputAction.done,
                                controller: _decController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: '请填写您对车辆的要求',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              // _submit();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 30.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0XFF2B95E9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                // gradient: LinearGradient(colors: [
                                //   Color(0xFFFF7F16),
                                //   Color(0xFFEF3500)
                                // ])
                              ),
                              child: Text(
                                '提交',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // child: Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: MaterialButton(onPressed: () {
                    //     Picker(
                    //         adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(PickerData2), isArray: true),
                    //         hideHeader: true,
                    //         title: new Text("Please Select"),
                    //         onConfirm: (Picker picker, List value) {
                    //           print(value.toString());
                    //           print(picker.getSelectedValues());
                    //         }
                    //     ).showDialog(context);
                    //   },
                    //   ),
                    // ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
