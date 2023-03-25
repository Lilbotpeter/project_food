//Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final User? user = Auth().currentUser;

//Create Class
class Auth {
//instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Current User
  User? get currentUser => _firebaseAuth.currentUser;

  //Session ?
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  //Login
  Future<void> signInWithEmailAndPassword({
    //Parameter
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Regiter
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    //required name ,phone,data user
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('Person').add({
      'Email': user?.email,
      'Uid': user?.uid,
      'Name': '',
      'ImageP': '',
      'Phone': ''
    });
  }

  //Logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
