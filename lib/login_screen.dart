import 'package:flutter/material.dart';
import 'package:to_do_list_app1/todopage.dart'; // Adjust the import path as per your project structure

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String correctPassword = "ghaza123"; // Define the correct password here
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  colors: [Colors.blue.shade800, Colors.deepPurple.shade800],
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
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _emailController,
                cursorColor: Colors.indigo,
                keyboardType: TextInputType.emailAddress, // Specify email keyboard type
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Colors.indigo,
                  ),
                  hintText: "Enter email",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                cursorColor: Colors.indigo,
                keyboardType: TextInputType.text, // Specify text keyboard type (default)
                textInputAction: TextInputAction.done, // Set action button to "Done"
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.vpn_key,
                    color: Colors.indigo,
                  ),
                  hintText: "Enter password",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Check if the entered password is correct
                if (_passwordController.text == correctPassword) {
                  // Navigate to home page if the password is correct
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TodoListPage()),
                  );
                } else {
                  // Show error message if the password is incorrect
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Incorrect Password"),
                        content: Text("Your password is wrong. Please try again."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
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
