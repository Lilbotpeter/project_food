import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Auth
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_food/screen/upload_food_page.dart';
import '../auth.dart';
import '../model/food_model.dart';

class DeletePage extends StatelessWidget {
  late DocumentReference _documentReference;
  late Future<DocumentSnapshot> _future;
  DeletePage(String id, {Key? key}) : super(key: key) {
    _documentReference = FirebaseFirestore.instance.collection('Foods').doc(id);
    _future = _documentReference.get();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // foodModels.
          _documentReference.delete();
          // final docker = FirebaseFirestore.instance
          //     .collection('Foods')
          //     .doc(id);
          // docker.delete();
        },
        child: Text('ลบข้อมูล'),
      ),
    );
  }
}
