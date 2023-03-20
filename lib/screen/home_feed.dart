import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_food/model/food_model.dart';
import 'package:project_food/model/profile_model.dart';

// import 'package:project_food/screen/edit_person.dart';
// import 'package:project_food/screen/upload_food_page.dart';

import '../auth.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  List<PersonModel> personModels = [];

  //Method ที่ทำงาน อ่านค่าที่อยู่ใน fire store
  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    //read data
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firestore.collection('Person'); //collection Person
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots =
          response.docs; //snapshot from firestore [array]
      for (var snapshot in snapshots) {
        PersonModel personModel =
            PersonModel.fromMap(snapshot.data() as Map<String, dynamic>);
        setState(() {
          personModels.add(personModel);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: ListView.builder(
              itemCount: personModels.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return Text(personModels[index].name);
                return Card(
                  child: Column(children: <Widget>[
                    showImage(index),
                    showName(
                      index,
                    ),
                    showEmail(index),
                    showPhone(index),
                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );

    //Stream<List<PersonModel>> readData
  }
}
