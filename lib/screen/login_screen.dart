import 'package:chatting_app/screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/provider/auth_provider.dart';
import 'package:chatting_app/screen/chatting_screen.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    bool isLoggedIn = await _authService.isUserLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => chattingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                User? user = await _authService.signInWithEmailPassword(email, password);
                if (user != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => chattingScreen()));
                } else {
                  print('Login failed');
                }
              },
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text('Register'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
