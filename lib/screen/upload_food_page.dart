import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_food/api/firebase_api.dart'; //import api for upload
import 'package:project_food/main.dart';
import 'package:project_food/widgets/button_widget.dart';
import 'package:path/path.dart'; //import for basename

class UploadFoodPage extends StatefulWidget {
  const UploadFoodPage({Key? key}) : super(key: key);

  @override
  State<UploadFoodPage> createState() => _UploadFoodPageState();
}

class _UploadFoodPageState extends State<UploadFoodPage> {
  UploadTask? task;
  File? file; //file can null
  PlatformFile? pickedFile;

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

  //Future

  //Function uploadFile
  Future uploadFile() async {
    if (file == null) return;

    final filename = basename(file!.path); //get filename
    final destination = 'files/$filename'; //destination

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Dowload-Link: $urlDownload');
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
                msg: "Added Success!",
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

  @override
  Widget build(BuildContext context) {
    final filename = file != null
        ? basename(file!.path)
        : 'No file Selected!'; //set basename
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upload Food'),
      //   centerTitle: true,
      //   ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                text: 'Select File',
                onClick: selectFile),
            SizedBox(
              height: 8,
            ),
            Text(
              filename,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 48.0,
            ), //Under filename for "Spacebar naja"
            ButtonWidget(
                //Button Upload file
                icon: Icons.attach_file,
                text: 'Upload File',
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
