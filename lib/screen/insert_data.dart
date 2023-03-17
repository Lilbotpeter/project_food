import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_food/screen/display_data.dart';

//Authen import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_food/auth.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  //เตรียม Firebase
  //final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late DatabaseReference dbRef;

  //Authen Current User
  final User? user = Auth().currentUser;
  //logout
  Future<void> signOut() async {
    await Auth().signOut();
  }

  //Widget Show Current User
  Widget _userUID() {
    return Text(user?.email ?? 'User email');
  }

  //Widget Logout Button
  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out!'),
    );
  }

  /////////////////

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Comment');
  }

  void clearText() {
    nameController.clear();
    emailController.clear();
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
          child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(label: Text("Comment:")),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(label: Text("From:")),
          ),
          ElevatedButton(
              onPressed: () {
                print("Button Worked!");
                Map<String, String> commentU = {
                  'comment': nameController.text,
                  'from': emailController.text
                };

                dbRef.push().set(commentU);
                clearText();

                Fluttertoast.showToast(
                    msg: "Added Success!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Display()),
                // );
              },
              child: Text("Post"))
        ],
      )),
    );
  }
}
