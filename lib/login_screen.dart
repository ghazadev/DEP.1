import 'package:flutter/material.dart';
import 'todopage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Colors.blue,
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset('images/appicon.jpg'),
                      height: 120,
                      width: 120,
                    ),
                    Container(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left:20,right:20,top:60),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,10),
                        blurRadius: 50,
                        color: Colors.blueAccent,
                      ),
                    ]
                ),
                alignment: Alignment.center,
                child: TextField(
                  cursorColor: Colors.indigo,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.email ,
                        color: Colors.indigo,
                      ),
                      hintText: "Enter email",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.only(left:20,right:20,top:20),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,10),
                        blurRadius: 50,
                        color: Colors.blueAccent,
                      ),
                    ]
                ),
                alignment: Alignment.center,
                child: TextField(
                  obscureText: true,
                  cursorColor: Colors.indigo,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.vpn_key ,
                        color: Colors.indigo,
                      ),
                      hintText: "Enter password",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                  ),
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 20,right: 20),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Text("Forget Password?"),
                onTap: () {
                  // Handle forgot password action here
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to home page on login button tap
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TodoListPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 40,right: 40, top: 70),
                padding: EdgeInsets.only(left: 20,right: 20),
                alignment: Alignment.center,
                height: 54,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,10),
                        blurRadius: 50,
                        color: Colors.blueAccent,
                      ),
                    ]
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 20,
                    color:Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


