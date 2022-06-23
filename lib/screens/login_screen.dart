import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/button_padding.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showModal = false;
  String? email;
  String? password;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showModal,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
              ),
              SizedBox(
                height: 20.0,
                child: Center(
                  child: Text(errorText,
                  style: const TextStyle(
                    color: Colors.black54
                  ),
                  ),
                ),
              ),
              ButtonPadding(
                text: 'Log in',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState((){
                    showModal = true;
                  });
                  try{
                    final user = await _auth.signInWithEmailAndPassword(email: email!, password: password!);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  }on FirebaseAuthException catch(e){
                    if (e.code == 'user-not-found'){
                      setState((){
                        errorText = 'User not found!, try to register';
                      });
                    }else if (e.code == 'wrong-password'){
                      setState((){
                        errorText = 'Password is invalid!';
                      });
                    }
                  }
                  catch(e){
                    setState((){
                      errorText = 'internal error occurred';
                    });
                  }
                  setState((){
                    showModal = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
