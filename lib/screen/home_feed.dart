import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Auth
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_food/screen/upload_food_page.dart';
import '../auth.dart';
import '../model/food_model.dart';

//Authen Current User *
final User? user = Auth().currentUser;

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  List<FoodModel> foodModels = [];

  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_description = TextEditingController();
  final TextEditingController edit_ingredients = TextEditingController();
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
        firestore.collection('Foods'); //collection Person  //await
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots =
          response.docs; //snapshot from firestore [array]
      for (var snapshot in snapshots) {
        //print("object");
        FoodModel foodModel =
            FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
        foodModel.food_id = snapshot.id;

        setState(() {
          //print("object");
          foodModels.add(foodModel);
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
        foodModels[index].food_image,
      ),
    );
  }

  Widget showName(int index) {
    return Text(
      foodModels[index].food_name,
    );
  }

  Widget showDescription(int index) {
    return Text(
      foodModels[index].food_description,
    );
  }

  Widget showIngredients(int index) {
    return Text(
      foodModels[index].food_ingredients,
    );
  }

//-------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------
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
          //_signOutButton(),
          new IconButton(
            icon: new Icon(Icons.search),
            highlightColor: Colors.pink,
            onPressed: () {
              print('Search Strat');
            },
          ),
        ],
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: ListView.builder(
              itemCount: foodModels.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return Card(
                  child: Column(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Image.network(
                          foodModels[index].food_image,
                        )),
                    showName(
                      index,
                    ),
                    showDescription(index),
                    showIngredients(index),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print('Start NaJa');

                          print(foodModels[index].food_id);
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('แก้ไขสูตรอาหาร'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("ชื่อสูตรอาหาร"),
                                      TextFormField(
                                        controller: edit_name,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                      Text("วัตถุดิบ"),
                                      TextFormField(
                                        controller: edit_ingredients,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                      Text("รายละเอียด"),
                                      TextFormField(
                                        controller: edit_description,
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
                                      late String _editname = edit_name.text;
                                      late String _editingredients =
                                          edit_ingredients.text;
                                      late String _editdescription =
                                          edit_description.text;
                                      final docker = FirebaseFirestore.instance
                                          .collection('Foods')
                                          .doc(foodModels[index].food_id);
                                      docker.update({
                                        'Food_Description': _editdescription,
                                        'Food_Ingredients': _editingredients,
                                        'Food_Name': _editname,
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
                        onPressed: () {
                          print('Start NaJa');

                          print(foodModels[index].food_id);
                          final docker = FirebaseFirestore.instance
                              .collection('Foods')
                              .doc(foodModels[index].food_id);
                          //docker.delete();
                          docker.delete();
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

// Widget textFontF(TextEditingController controller) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//     ),
//   );
// }
