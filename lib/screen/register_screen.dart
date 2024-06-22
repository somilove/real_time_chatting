import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/provider/auth_provider.dart';
import 'package:chatting_app/screen/chatting_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              child: Text('Register'),
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                User? user = await _authService.registerWithEmailPassword(email, password);
                if (user != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => chattingScreen()));
                } else {
                  print('Registration failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
