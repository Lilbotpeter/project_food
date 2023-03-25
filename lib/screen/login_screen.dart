import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:project_food/widgets/text_field_input.dart';

//Auth
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Login Part
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _loginEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _loginEmail.text,
        password: _loginPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _loginEmail.text,
        password: _loginPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  //

  Widget _title() {
    return const Text('Login');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.amber),
        ),
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'We found: $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
      style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register' : 'Login',
          style: TextStyle(
              color: Colors.orange, fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget showLogo() {
    return Container(
      width: 250.0,
      height: 250.0,
      child: Image.asset('images/logo.png'),
    );
  }

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

  // @override
//   void dispose(){
//     super.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: <Widget>[
          showLogo(),
          _entryField('email', _loginEmail),
          SizedBox(
            height: 12.0,
          ),
          _entryField(
            'password',
            _loginPassword,
          ),
          _errorMessage(),
          _submitButton(),
          _loginOrRegisterButton(),
        ]),
      ),
    );
  }
}


//old form
//       return Scaffold(
//         body: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             width: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Flexible(child: Container(),flex: 2),
//                 //image
//                 // SvgPicture.asset('assets/logo.svg',
//                 // color: Colors.black,
//                 // height: 64,
//                 // ),
//                 const SizedBox(height: 64),
//                 //text field Email
//                 TextFieldInput(
//                   hintText: 'Enter Your Email',
//                   textInputType: TextInputType.emailAddress,
//                   textEditingController: _emailController,
//                 ),
//                 const SizedBox(height: 24),
//                 //text field Password
//                 TextFieldInput(
//                   hintText: 'Enter Your Password',
//                   textInputType: TextInputType.text,
//                   textEditingController: _passwordController,
//                   isPass: true,
//                 ),

//                 const SizedBox(height: 24),

//                 //Login Button
//                 // InkWell(
//                 //   child: Container(
//                 //     child: const Text('Log in'),
//                 //     width: double.infinity,
//                 //     alignment: Alignment.center,
//                 //     padding: const EdgeInsets.symmetric(vertical: 12),
//                 //     decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.all(
//                 //         Radius.circular(4)
//                 //       ),
//                 //     ),
//                 //     color: Colors.orange,
//                 //     ),
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 64),
//                 // Flexible(child: Container(),flex: 2),

                 
//                 //Sign up
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       child: Text("Don't have an account?"),
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                     GestureDetector(
//                       onTap: (){},
//                       child: Container(
//                         child: Text("Sign up.",style: TextStyle(fontWeight: FontWeight.bold
//                         ),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                       ),
//                     ),
                  
                    
//                   ],
//                 )
//               ]),
//             )
//           ),
      
//     );