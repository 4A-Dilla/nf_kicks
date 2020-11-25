import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FormType { login, register }

class LoginAndRegistrationPage extends StatefulWidget {
  @override
  _LoginAndRegistrationPageState createState() =>
      _LoginAndRegistrationPageState();
}

class _LoginAndRegistrationPageState extends State<LoginAndRegistrationPage> {
  FormType _formType = FormType.login;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _toggleFormType() {
    setState(() {
      _formType =
          _formType == FormType.login ? FormType.register : FormType.login;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Form _formFields() {
    if (_formType == FormType.login) {
      return Form(
        key: _formKey,
        child: Column(
          children: <TextField>[
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'E-Mail',
                suffixIcon: Icon(Icons.email),
                hintText: 'yourname@example.com',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    _toggle();
                  },
                  icon: Icon(_obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
                hintText: 'yourpassword',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: _obscureText,
            ),
          ],
        ),
      );
    } else {
      return Form(
        key: _formKey,
        child: Column(
          children: <TextField>[
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'E-Mail',
                hintText: 'yourname@example.com',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'yourpassword',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                hintText: 'yourpassword',
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.orangeAccent.withOpacity(0.2)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      scale: 7,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      _formType == FormType.login ? "Login" : "Sign up",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.white,
                          child: Container(
                            height: 50,
                            width: 80,
                            child: Image.asset(
                              "assets/google.png",
                              scale: 29,
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.white,
                          child: Container(
                            height: 50,
                            width: 80,
                            child: Image.asset(
                              "assets/facebook.png",
                              scale: 29,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _formFields(),
                    SizedBox(
                      height: 40,
                    ),
                    ButtonTheme(
                      minWidth: 200.0,
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          _formType == FormType.login ? "Login" : "Sign Up",
                          style: GoogleFonts.josefinSans(
                            textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formType == FormType.login
                              ? "Don't have an account?"
                              : "Already have an account?",
                          style: GoogleFonts.josefinSans(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => _toggleFormType(),
                          child: Row(
                            children: [
                              Text(
                                _formType == FormType.login
                                    ? "Sign up"
                                    : "Login",
                                style: GoogleFonts.josefinSans(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
