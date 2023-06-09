import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_food/screen/display_data.dart';
import 'package:project_food/screen/homefeed_page.dart';
import 'package:project_food/screen/insert_data.dart';
import 'package:project_food/responsive/mobile_screen_layout.dart';
import 'package:project_food/screen/login_screen.dart';
import 'package:project_food/screen/profile_page.dart';
import 'screen/display_data.dart';
import 'screen/myfood_page.dart';
import 'screen/upload_food_page.dart';
import 'package:project_food/responsive/responsive_layout.dart';
import 'package:project_food/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.amber,
            selectionColor: Colors.amber,
            selectionHandleColor: Colors.amber,
          )),
      //home: LoginScreen(),
      // home: const ReponsiveLayout(
      //   mobileScreenLayout: MoblieScreenLayout()
      //   ),
      //home: const MyHomePage(),
      home: WidgetTree(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curIndex = 0;

  final tabs = [
    HomepageFeed(),
    MyfoodPage(),
    UploadFoodPage(),
    ProfilePage(),
  ];

  void onTabTap(int index) {
    //Current tab
    setState(() {
      _curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/logo.png',
            //   scale: 12,
            // ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'FoodHomeworkCommu',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.orange, //<-- SEE HERE
      ),
      body: tabs[_curIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTap,
        currentIndex: _curIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าหลัก',
              backgroundColor: Color.fromARGB(255, 248, 60, 2)),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'สูตรของฉัน',
              backgroundColor: Color.fromARGB(255, 248, 60, 2)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'เพิ่มสูตร',
              backgroundColor: Color.fromARGB(255, 248, 60, 2)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'โปรไฟล์',
              backgroundColor: Color.fromARGB(255, 248, 60, 2)),
        ],
      ),
    );
  }
}
