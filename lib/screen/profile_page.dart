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
  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_email = TextEditingController();
  final TextEditingController edit_phon = TextEditingController();
  @override
  void initState() {
    super.initState();
    readPerson();
  }

  Future<void> readPerson() async {
    //read data
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('Person'); //collection Person  //await
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots =
          response.docs; //snapshot from firestore [array]
      for (var snapshot in snapshots) {
        //print("object");
        PersonModel personModel =
            PersonModel.fromMap(snapshot.data() as Map<String, dynamic>);

        //personModel.uid = snapshot.id;
        //print("Statrt setState");
        setState(() {
          if (personModel.uid == user?.uid) {
            personModels.add(personModel);
          }
          personModel.uid = snapshot.id;
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

  Widget showName(int index) {
    return Text(
      personModels[index].name,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  Widget showEmail(int index) {
    return Text(
      personModels[index].email,
    );
  }

  Widget showPhone(int index) {
    return Text(personModels[index].phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _userUID(),
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
                    showEmail(index),
                    showName(index),
                    showPhone(index),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          print('Start NaJa');

                          print(personModels[index].uid);

                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(''),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("แก้ไขข้อมูลผู้ใช้"),
                                      Text("ชื่อผู้ใช้ : "),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: edit_name,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                      Text("อีเมล : "),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: edit_email,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                      Text("เบอร์โทร : "),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: edit_phon,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('ยืนยันการแก้ไข'),
                                    onPressed: () {
                                      print('Update NaJa');

                                      print(personModels[index].uid);
                                      late String _editname = edit_name.text;
                                      late String _editemail = edit_email.text;
                                      late String _editphon = edit_phon.text;
                                      final docker = FirebaseFirestore.instance
                                          .collection('Person')
                                          .doc(personModels[index].uid);
                                      docker.update({
                                        'Email': _editemail,
                                        'Name': _editname,
                                        'Phone': _editphon,
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('แก้ไขข้อมูล'),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          print('Delete NaJa');

                          print(personModels[index].uid);
                          final docker = FirebaseFirestore.instance
                              .collection('Person')
                              .doc(personModels[index].uid);
                          //docker.delete();
                          docker.delete();
                          signOut();
                        },
                        child: Text('ลบข้อมูล'),
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
