import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_food/api/firebase_api.dart'; //import api for upload
import 'package:project_food/main.dart';
import 'package:project_food/model/profile_model.dart';
import 'package:project_food/screen/home_feed.dart';
import 'package:project_food/widgets/button_widget.dart';
import 'package:path/path.dart'; //import for basename
import 'package:project_food/widgets/text_field_data.dart';

import 'package:project_food/widgets/text_field_input.dart';
import 'package:project_food/screen/edit_person.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final collectionRef =
  //     FirebaseFirestore.instance.collection('Person').doc('Uid').get();

  //read data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: ListView.builder(
              itemBuilder: (BuildContext buildContext, int index) {
                return Card(
                  child: Column(children: <Widget>[
                    // showImage(index),
                    // showName(
                    //   index,
                    // ),
                    // showEmail(index),
                    // showPhone(index),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print("Success");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditPage()),
                          );
                        },
                        child: Text('แก้ไขข้อมูล'),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
