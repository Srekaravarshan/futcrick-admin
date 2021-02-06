import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/AuthService.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/main.dart';
import 'package:provider/provider.dart';

final TextEditingController _emailController = new TextEditingController();
final TextEditingController _passwordController = new TextEditingController();

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TextField(
          //   controller: _emailController,
          //   decoration: InputDecoration(
          //       border: OutlineInputBorder(borderSide: BorderSide(color: iconColor)),
          //       labelText: 'Email address'
          //   ),
          // ),
          // TextField(
          //   controller: _passwordController,
          //   decoration: InputDecoration(
          //     border: OutlineInputBorder(borderSide: BorderSide(color: iconColor)),
          //     labelText: 'Password',
          //   ),
          // ),
          // RaisedButton(onPressed: (){
          //   context.read<AuthService>().signUp(_emailController.text.trim(), _passwordController.text.trim());
          // }, child: Text('Sign up')),
          RaisedButton(
                  onPressed: () async {
                    await context.read<AuthService>().signUpWithGoogle();
                    // final User _firebaseUser = context.watch<User>();
                    final User _firebaseUser =
                        Provider.of<User>(context, listen: false);
                    await usersRef.doc(_firebaseUser.uid).set({
                      'displayName': _firebaseUser.displayName != null
                          ? _firebaseUser.displayName
                          : 'Anonymous',
                      'uid': _firebaseUser.uid,
                      'email': _firebaseUser.email,
                      'photoURL': _firebaseUser.photoURL,
                    });
                  },
                  child: Text('Sign up with google'))
              .center(),
        ],
      ),
    );
  }
}
