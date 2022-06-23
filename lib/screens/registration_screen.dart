import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/button_padding.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>{
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  String errorText = '';
  bool showModal = false;

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
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
              ),
              SizedBox(
                height: 20.0,
                child: Center(
                  child: Text( errorText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
              ButtonPadding(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState((){
                    showModal = true;
                  });
                  try {
                    UserCredential newUser = await _auth.createUserWithEmailAndPassword(
                        email: email!, password: password!);
                    if (newUser != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  }on FirebaseAuthException catch (e){
                    if (e.code == 'email-already-in-use'){
                      setState((){
                        errorText = 'The email address already exists.';
                      });
                    } else if (e.code == 'password-too-weak'){
                      setState((){
                        errorText = 'Password is too weak.';
                      });
                    }
                  }
                  catch (e){
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
