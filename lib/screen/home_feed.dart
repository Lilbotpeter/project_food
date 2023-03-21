import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Auth
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_food/screen/upload_food_page.dart';
import '../auth.dart';
import '../model/food_model.dart';
import '../screen/deletepage.dart';

//Authen Current User *
final User? user = Auth().currentUser;

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  List<FoodModel> foodModels = [];
  final edit_name = TextEditingController();
  final edit_description = TextEditingController();
  final edit_ingredients = TextEditingController();
  //Method ที่ทำงาน อ่านค่าที่อยู่ใน fire store

  @override
  void initState() {
    //print("Program Start I Kuay");
    super.initState();
    readData();
  }

// _HomeFeedState(String id, {Key? key}) : super(key: key) {
//    // _documentReference = FirebaseFirestore.instance.collection('Foods').doc(id);
//    // _future = _documentReference.get();
//   }

  Future<void> readData() async {
    print("Program Start I Kuay");

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
//final collectionRef = FirebaseFirestore.instance.collection('Foods');

// Replace 'AUTO_GENERATED_ID' with the ID of the document you want to delete
////final documentRef = collectionRef.doc('AUTO_GENERATED_ID');

// Delete the document
//documentRef.delete();
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
          _signOutButton(),
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
                    Text('Kuay'),
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
                          final docker = FirebaseFirestore.instance
                              .collection('Foods')
                              .doc(foodModels[index].food_name);
                          docker.update({
                            'Food_Description': edit_name,
                            'Food_Ingredients': edit_description,
                            'Food_Name': edit_ingredients,
                          });
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
