import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_food/model/profile_model.dart';

import '../auth.dart';

final User? user = Auth().currentUser;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<PersonModel> personModels = [];

  // String s1 = "dfkjhkdfhk";
  // String s2 = "789456123";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    readPerson();
  }

  Future<void> readPerson() async {
    //read data
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('users'); //collection Person  //await
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots =
          response.docs; //snapshot from firestore [array]
      for (var snapshot in snapshots) {
        //print("object");
        PersonModel personModel =
            PersonModel.fromMap(snapshot.data() as Map<String, dynamic>);

        //personModel.uid = snapshot.id;

        setState(() {
          //print("object");
          personModels.add(personModel);
        });
      }
    });
  }

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
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: signOut,
      child: const Text('ออกจากระบบ'),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(user!.email ?? '');
    print(user!.phoneNumber ?? '');
    print('photoURL');
    print(user!.photoURL ?? '');
    print(user?.uid ?? '');

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
            child: Column(
          children: <Widget>[
            _signOutButton(),
          ],
        )),
      )),
    );
  }
}
