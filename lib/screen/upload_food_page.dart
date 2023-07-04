import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_food/api/firebase_api.dart'; //import api for upload
import 'package:project_food/main.dart';
import 'package:project_food/screen/myfood_page.dart';
import 'package:project_food/widgets/button_widget.dart';
import 'package:path/path.dart'; //import for basename
import 'package:project_food/widgets/text_field_data.dart';

import 'package:project_food/widgets/text_field_input.dart';

import '../auth.dart';

class UploadFoodPage extends StatefulWidget {
  const UploadFoodPage({Key? key}) : super(key: key);

  @override
  State<UploadFoodPage> createState() => _UploadFoodPageState();
}

class _UploadFoodPageState extends State<UploadFoodPage> {
  UploadTask? task;

  final User? user = Auth().currentUser;

  File? file; //file can null
  PlatformFile? pickedFile;
  String? food_id;
  String? urlDownload,
      food_name = '',
      food_video,
      food_level,
      food_ingredients,
      food_solution,
      food_type,
      food_description,
      food_time,
      food_nation,
      food_point;

  //Current UID
  Widget _userUID() {
    return Text(user?.uid ?? 'User UID');
  }

  //In&Out File Part
  //Function selectFile
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple:
            false); //File picker allowMultiple : can select multiple file.

    if (result == null) return;
    final path = result.files.single.path!; //path a single file

    setState(() => file = File(path)); //file path

    setState(() {
      pickedFile = result.files.first; //picked file
    });
  }

  //Function uploadFile
  Future uploadFile() async {
    if (file == null) return;

    final filename = basename(file!.path); //get filename
    final destination = 'files/$filename'; //destination

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    print('Dowload-Link: $urlDownload');

    insertDataToFireStore(); //insert daTA
  }

  //Upload Status %
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!; //snapshot data
            final progress = snap.bytesTransferred /
                snap.totalBytes; //% progress raw percent
            final percen =
                (progress * 100).toStringAsFixed(2); //Percent 100% 0.00
            if (progress.isFinite) {
              Fluttertoast.showToast(
                msg: "อัพโหลดสำเร็จ!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0,
                backgroundColor: Colors.amber,
              );
            }
            return Text(
              '$percen %',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          } else {
            return Container();
          }
        },
      );

  //Insert Data To firebase
  Future<void> insertDataToFireStore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final docUser =
        FirebaseFirestore.instance.collection('Foods').doc(); //Foods document

    Map<String, dynamic> dataMap = Map(); //dynamic = data type everything
    dataMap['Food_id'] = food_id;
    dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
    dataMap['Food_Image'] = urlDownload;
    dataMap['Food_Video'] = food_video;
    dataMap['Food_Level'] = food_level;
    dataMap['Food_Ingredients'] = food_ingredients;
    dataMap['Food_Solution'] = food_solution;
    dataMap['Food_Type'] = food_type;
    dataMap['Food_Description'] = food_description;
    dataMap['Food_Time'] = food_time;
    dataMap['Food_Nation'] = food_nation;
    dataMap['Food_Point'] = food_point;
    dataMap['User_id'] = user?.uid;

    await firestore.collection('Foods').doc().set(dataMap).then((value) {
      print('Insert Success' + '$user?.uid');
      MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => MyfoodPage(),
      ); //Route to Home_feed
      //Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
  }

  void onNameChanged(String value) {
    setState(() {
      food_name = value.trim();
      // if (value.isEmpty) {
      //   food_name = 'N/A';
      // } else {
      //   food_name = value.trim();
      // }
    });
  }

  Widget name(context) {
    return TextField(
      onChanged: onNameChanged,
      decoration: InputDecoration(
        icon: Icon(Icons.format_align_center),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget ingredients(context) {
    return TextField(
      onChanged: (value) {
        food_ingredients = value.trim();
      },
      decoration: InputDecoration(
        icon: Icon(Icons.dinner_dining),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget description(context) {
    return TextField(
        onChanged: (value) {
          food_description = value.trim();
        },
        decoration: InputDecoration(
          icon: Icon(Icons.description),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  //Form Input
  Widget showForm(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          name(context),
          SizedBox(
            height: 12.0,
          ),
          ingredients(context),
          SizedBox(
            height: 12.0,
          ),
          description(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filename = file != null
        ? basename(file!.path)
        : 'ยังไม่มีไฟล์ที่เลือก!'; //set basename
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upload Food'),
      //   centerTitle: true,
      //   ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Container(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.amber,
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ButtonWidget(
                //Button Select file
                icon: Icons.attach_file,
                text: 'เลือกไฟล์',
                onClick: selectFile),
            SizedBox(
              height: 8,
            ),
            // Text(
            //   ('$filename'),
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(
              height: 15.0,
            ), //Under filename for "Spacebar naja"
            showForm(context),
            SizedBox(
              height: 15.0,
            ),
            ButtonWidget(
                //Button Upload file
                icon: Icons.upload_file_sharp,
                text: 'อัพโหลด',
                onClick: uploadFile),
            SizedBox(
              height: 20,
            ),
            task != null ? buildUploadStatus(task!) : Container() //Percent
          ],
        )),
      ),
    );
  }
}
