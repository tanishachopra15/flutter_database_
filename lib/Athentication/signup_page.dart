import 'package:FLUTTER_DATABASE_/Athentication/auth_page.dart';
import 'package:FLUTTER_DATABASE_/Athentication/login_page.dart';
import 'package:FLUTTER_DATABASE_/pages/home_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
  bool passwordObscure = true;
  final _firebaseAuth = Authentication();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _signUp() async {
    final user =
        await _firebaseAuth.singUpUser(_email.text.trim(), _password.text);
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
        backgroundColor: Colors.red,
        title: const Text('SignUp Page',
            style: TextStyle(
              color: Colors.blue,
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Email';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return 'Please Enter a valid email';
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(passwordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your password';
                        } else if (value.length <= 6) {
                          return 'Password should be mor than 6 characters';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signUp();
                            _email.clear();
                            _password.clear();
                          }
                        },
                        child: const Text('Sign Up')),
                  ],
                )),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an Account !"),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(' Log in',
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
