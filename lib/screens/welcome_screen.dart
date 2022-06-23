import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/button_padding.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController? controller;
  Animation? animation;
  Animation? animation1;

  @override
  void initState (){
    super.initState();
    controller = AnimationController(vsync: this,
        duration: const Duration(seconds: 3));
    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

    animation1 = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller!);
    controller!.forward();

    controller!.addListener(() {
      setState((){

      });
    });
  }
  @override
  void dispose(){
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation1!.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: animation!.value*100,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Flash Chat',
                    speed: const Duration(milliseconds: 200),
                    textStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),)
                  ],
                  totalRepeatCount: 2,
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            ButtonPadding(
              text: 'Log in',
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ButtonPadding(
              text: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
