import 'dart:ui';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/pages/loading_page.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/widgets/background_stack.dart';
import 'package:password_compromised/password_compromised.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';

enum FormType { login, register }

class LoginAndRegistrationPage extends StatefulWidget {
  @override
  _LoginAndRegistrationPageState createState() =>
      _LoginAndRegistrationPageState();
}

class _LoginAndRegistrationPageState extends State<LoginAndRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  FormType _formType = FormType.login;

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthenticationApi>(context, listen: false);
      await auth.loginWithFacebook();
    } on FirebaseException catch (e) {
      print("my exception : $e");
      showAlertDialog(context,
          title: 'Sign in failed', content: e.message, defaultActionText: 'OK');
    } finally {
      if (this.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthenticationApi>(context, listen: false);
      await auth.loginWithGoogle();
    } on FirebaseException catch (e) {
      print("my exception : $e");
      showAlertDialog(context,
          title: 'Sign in failed', content: e.message, defaultActionText: 'OK');
    } finally {
      if (this.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthenticationApi>(context, listen: false);
      if (_formType == FormType.login) {
        await auth.loginWithEmailAndPassword(_email, _password);
      } else {
        final compromised = await isPasswordCompromised(_password);
        if (compromised) {
          showAlertDialog(context,
              title: 'Sign in failed',
              content:
                  'The password you have chosen has been compromised choose another.',
              defaultActionText: 'OK');
        } else {
          await auth.createUserWithEmailAndPassword(_email, _password);
        }
      }
    } on FirebaseAuthException catch (e) {
      showAlertDialog(context,
          title: 'Sign in failed', content: e.message, defaultActionText: 'OK');
    } finally {
      if (this.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType =
          _formType == FormType.login ? FormType.register : FormType.login;
    });
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _togglePasswordField() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Form _formFields() {
    if (_formType == FormType.login) {
      return Form(
        key: _formKey,
        child: Column(
          children: <TextFormField>[
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value.isEmpty) {
                  return "E-Mail field is required";
                }
                return null;
              },
              controller: _emailController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                labelText: 'E-Mail',
                suffixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                hintText: 'yourname@example.com',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusColor: Colors.white,
              ),
              cursorColor: Colors.white,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value.isEmpty) {
                  return "Password field is required";
                }
                return null;
              },
              controller: _passwordController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    _togglePasswordField();
                  },
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white,
                  ),
                ),
                hintText: 'yourpassword',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusColor: Colors.white,
              ),
              cursorColor: Colors.white,
              obscureText: _obscureText,
            ),
          ],
        ),
      );
    } else {
      final emailValidator = MultiValidator([
        RequiredValidator(errorText: 'Email is required'),
        EmailValidator(errorText: 'Please enter a valid email'),
      ]);

      final passwordValidator = MultiValidator([
        RequiredValidator(errorText: 'Password is required'),
        MinLengthValidator(8,
            errorText: 'Password must be at least 8 digits long'),
        MaxLengthValidator(127,
            errorText: 'Password must be under 127 digits long'),
        PatternValidator(r'(?=.*?[#?!@$%^&*-])',
            errorText: 'Passwords must have at least one special character')
      ]);

      return Form(
        key: _formKey,
        child: Column(
          children: <TextFormField>[
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: emailValidator,
              controller: _emailController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                labelText: 'E-Mail',
                suffixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                hintText: 'yourname@example.com',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusColor: Colors.white,
              ),
              cursorColor: Colors.white,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: passwordValidator,
              controller: _passwordController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    _togglePasswordField();
                  },
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white,
                  ),
                ),
                hintText: 'yourpassword',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusColor: Colors.white,
              ),
              cursorColor: Colors.white,
              obscureText: _obscureText,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value != _password) {
                  return "Passwords must match!";
                }
                return null;
              },
              controller: _confirmPasswordController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                labelText: 'Confirm Password',
                hintText: 'confirm yourpassword',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusColor: Colors.white,
              ),
              cursorColor: Colors.white,
              obscureText: _obscureText,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Loading(
        loadingWidget: kLoadingLogo,
      );
    }
    return Scaffold(
      body: backgroundStack(
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Image.asset(
                "assets/logo.png",
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () => _loginWithGoogle(context),
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
                    onPressed: () => _loginWithFacebook(context),
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
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    _formType == FormType.login ? "Login" : "Sign Up",
                    style: GoogleFonts.permanentMarker(
                      textStyle: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () =>
                      _formKey.currentState.validate() ? _submit() : null,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formType == FormType.login
                        ? "Don't have an account?"
                        : "Already have an account?",
                    style: GoogleFonts.permanentMarker(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
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
                          _formType == FormType.login ? "Sign up" : "Login",
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
    );
  }
}
