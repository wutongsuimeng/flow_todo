import 'package:flutter/material.dart';
import 'package:flow_todo/calendar.dart';
import 'package:flow_todo/person.dart';
import 'package:flow_todo/todo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh','CH'),
        const Locale('en','US'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: '代办',
        backgroundColor:Colors.blue,
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: '日程'
    ),
    // BottomNavigationBarItem(
    //     icon: Icon(Icons.person),
    //     label: '个人'
    // ),
  ];

  // final pages = [HomePage(), MsgPage(), CartPage(), PersonPage()];
  final pages = [TodoPage(), CalendarPage(), PersonPage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('工具栏'),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        // type: BottomNavigationBarType.shifting,
        onTap: onTabChanged,
      ),
      body: pages[currentIndex],
    );
  }

  //Tab改变
  void onTabChanged(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}
