import 'package:flash_chat/constants.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "/registration";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
            Hero(
              tag: "flash",
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Enter your password',
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onTap: () {
                //Implement registration functionality.
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
