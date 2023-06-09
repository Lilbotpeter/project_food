import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_food/screen/reply_food.dart';

import '../auth.dart';
import '../model/food_model.dart';

class HomepageFeed extends StatefulWidget {
  const HomepageFeed({Key? key}) : super(key: key);

  @override
  State<HomepageFeed> createState() => _HomepageFeedState();
}

class _HomepageFeedState extends State<HomepageFeed> {
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

// _HomeFeedState(String id, {Key? key}) : super(key: key) {
//    // _documentReference = FirebaseFirestore.instance.collection('Foods').doc(id);
//    // _future = _documentReference.get();
//   }

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
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: ListView.builder(
              itemCount: foodModels.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return Card(
                  child: Column(children: <Widget>[
                    showImage(index),
                    showName(
                      index,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          print('Show Start');
                          readData();
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('รายละเอียด:'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("ชื่อสูตรอาหาร : "),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        foodModels[index].food_name,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text("วัตถุดิบ : "),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        foodModels[index].food_ingredients,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      // Text("วิธีการทำ : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_solution,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text("ระดับความยาก : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_level,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text("วิดิโอ : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_video,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text("ประเภท : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_type,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text("เวลาในการทำ : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_time,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text("สัญชาติอาหาร : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_nation,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text("คะแนนอาหาร : "),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      // Text(
                                      //   foodModels[index].food_point,
                                      // ),
                                      // SizedBox(
                                      //   height: 10.0,
                                      // ),
                                      Text("รายละเอียด : "),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        foodModels[index].food_description,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ReplyFood()),
                                        );
                                      },
                                      child: Text('ทำอาหาร')),
                                  TextButton(
                                    child: const Text('ปิด'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('ดูสูตรอาหาร'),
                      ),
                    ),
                    // IconButton(
                    //   icon: new Icon(Icons.edit),
                    //   highlightColor: Colors.pink,
                    //   onPressed: () {
                    //     print("kuay");
                    //     MaterialPageRoute route = MaterialPageRoute(
                    //       builder: (Index) => UploadFoodPage(),
                    //     );
                    //   },
                    // ),
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
