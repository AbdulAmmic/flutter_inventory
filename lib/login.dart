import 'package:appl/Dashboard.dart';
import 'package:appl/button.dart';
import 'package:appl/customBar.dart';
import 'package:appl/iconLogo.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String enteredUsername = usernameController.text.trim();
      String enteredPassword = passwordController.text.trim();

      String validUsername = '1';
      String validPassword = '1';

      if (enteredUsername == validUsername && enteredPassword == validPassword) {
        // Successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 170,
        backgroundColor: Color.fromARGB(19, 144, 202, 249),
        title: Center(
          child: CustomAppBar(),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Existing Widgets
              RoundedCartIcon(),
              SizedBox(height: 20),
              Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Login',
                  // Add your icon here if needed
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  // Add your icon here if needed
                ),
              ),
              SizedBox(height: 20),
              DynamicButton(
                buttonText: 'Login',
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
