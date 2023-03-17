// import 'dart:ffi';
// import 'dart:html';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

//Authen import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_food/auth.dart';

//Shimmer
//import '../widgets/shimmer_widget.dart';

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  //Authen Current User *
  final User? user = Auth().currentUser;

  //Loading Check , Shimming *
  List<Map> data=[];
  bool isLoading =false;

  //logout *
  Future<void> signOut() async {
    await Auth().signOut();
  }

  //Widget Show Current User *
  Widget _userUID() {
    return Text(user?.email ?? 'User email');
  }

  //Widget Logout Button *
  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out!'),
    );
  }

  //Firebase Ref *
  Query refQ = FirebaseDatabase.instance.ref().child('Comment');

  // @override
  // void initState(){
  //   super.initState();

  //   loadData();
  // }


  // Future loadData() async{
  //   setState(() => isLoading = true);
  //   await Future.delayed(Duration(seconds: 2),() {});



  //   setState(() => isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: Row(
          children: [
            const SizedBox(
              width: 100,
            ),
            _userUID()
          ],
        ),
        actions: [
          _signOutButton(),
        ],
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
          child: FirebaseAnimatedList(
        query: refQ,
        itemBuilder: (context, snapshot, animation, index) {
          Map comment = snapshot.value as Map;
          return Container(
            child: Column(children: <Widget>[ShowDisplay(comment: comment)]),
          );
        },
      )),
    );
  }

  Widget ShowDisplay({required Map comment}) {
    return Card(
        child: ListTile(
      title: Text(comment['comment']),
      subtitle: Text(comment['from']),
    ));
  }

  //Shimmer Widget for loading Data
  // Widget buildShimmer() => ListTile(
  //   title: ShimmerWidget.rectangular(height:16), //Shimmer rectangular
  //   subtitle: ShimmerWidget.rectangular(height: 14,), // Shimmer rectangular
    
  // );
}
