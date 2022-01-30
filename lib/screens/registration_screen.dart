import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "/registration";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: "flash",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Enter your password',
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 36.0,
            ),
            RoundedButton(
              color: Colors.blueAccent,
              controller: _controller,
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    _controller.success();
                    Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.pushNamed(context, ChatScreen.id);
                      _controller.reset();
                    });
                  }
                } on FirebaseAuthException catch (e) {
                  _controller.error();
                  Fluttertoast.showToast(msg: e.message!);
                  print(e);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _controller.reset();
                  });
                }
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
