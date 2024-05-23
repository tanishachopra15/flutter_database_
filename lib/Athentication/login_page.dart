import 'package:FLUTTER_DATABASE_/Athentication/auth_page.dart';
import 'package:FLUTTER_DATABASE_/Athentication/signup_page.dart';
import 'package:FLUTTER_DATABASE_/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  final _firebaseAuth = Authentication();
  final _email = TextEditingController();
  final _password = TextEditingController();

  _logIn(context) async {
    final user = await _firebaseAuth.logInUser(
        email: _email.text, password: _password.text);
    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Email'),
              controller: _email,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
              controller: _password,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () async {
                   await _logIn(context);
                      _email.clear();
                    _password.clear();
                  },
                  child: const Text('Login')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an Account !"),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text('Sign Up',
                      style: TextStyle(color: Colors.red)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
