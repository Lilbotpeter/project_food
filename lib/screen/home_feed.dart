import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_food/model/profile_model.dart';
import '../auth.dart';

//Authen Current User *
final User? user = Auth().currentUser;

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

  Widget showImage(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Image.network(
        personModels[index].pathImage,
      ),
    );
  }

  Widget showName(int index) {
    return Text(
      personModels[index].name,
      style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
    );
  }

  Widget showEmail(int index) {
    return Text(
      personModels[index].email,
    );
  }

  Widget showPhone(int index) {
    return Text(
      personModels[index].phone,
    );
  }

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
        child: Center(
          child: Container(
            child: ListView.builder(
              itemCount: personModels.length,
              itemBuilder: (BuildContext buildContext, int index) {
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
