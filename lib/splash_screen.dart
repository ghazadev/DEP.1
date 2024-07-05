import 'package:flutter/material.dart';
import 'package:to_do_list_app1/login_screen.dart';
import 'login_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  startTimer() async{
    var duration= Duration(seconds: 3);
    return new Timer(duration, loginRoute);

  }

  loginRoute(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => LoginScreen()

    ));
  }
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }
}

Widget initWidget() {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        
        Center(
          child: Container(
            child: Image.asset('images/appicon.jpg')
          ),
        )
      ],
    ),
  );
}
