import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/signup.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class SignIn extends ConsumerWidget {
  SignIn({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _signinKey = GlobalKey();
  final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: Form(
        key: _signinKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(image: AssetImage('assets/images/twitter_logo.png'), width: 150,),
            SizedBox(height: 20,),
            Text("Log in to Twitter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
                margin: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email";
                    } else if (!_emailRegex.hasMatch(value)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                )
            ),
            Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    } else if (value.length < 6) {
                      return "Enter more than 6 digits";
                    }
                    return null;
                  }
              ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: TextButton(onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                if (_signinKey.currentState!.validate()) {
                  try {
                    await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                    await ref.read(userProvider.notifier).signIn(_emailController.text);
                  } catch(e) {
                    messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              }, child: const Text("Log In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            TextButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupPage()));
            }, child: Text("Don't have an account? Sign up here", style: TextStyle(color: Colors.blue)),),
          ],
        ),
      ),
    );
  }
}