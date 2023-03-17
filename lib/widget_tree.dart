import 'package:project_food/auth.dart';
import 'package:project_food/screen/display_data.dart';
import 'package:project_food/main.dart';
import 'package:project_food/screen/login_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream : Auth().authStateChanges,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return MyHomePage();
        }else{
          return const LoginScreen();
        }
      },
    ); 
  }
}