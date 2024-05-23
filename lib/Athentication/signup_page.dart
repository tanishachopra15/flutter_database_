import 'package:FLUTTER_DATABASE_/Athentication/auth_page.dart';
import 'package:FLUTTER_DATABASE_/Athentication/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _MyHome(),
    );
  }
}

class _MyHome extends StatefulWidget {
  const _MyHome({super.key});

  @override
  State<_MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<_MyHome> {

  final _firebaseAuth = Authentication();
  final _email = TextEditingController();
  final _password = TextEditingController();

  _signUp()async{
    final user =await  _firebaseAuth.singUpUser(_email.text, _password.text);
    if(user != null){
      print('User has been created');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: const Text('SignUp Page'),
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
                  onPressed: () {
                    _signUp();
                    _email.clear();
                    _password.clear();
                  }, child: const Text('Sign Up')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an Account !"),
                InkWell(
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()));
                  },
                  child: const Text('Log in',
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
