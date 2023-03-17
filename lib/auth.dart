//Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';

//Create Class
class Auth{
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
  }) async{
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
  }

  //Logout
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}

