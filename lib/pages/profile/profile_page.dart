import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/nfkicksUser.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import 'package:password_compromised/password_compromised.dart';

import '../../constants.dart';
import '../loading_page.dart';

class ProfilePage extends StatefulWidget {
  final DatabaseApi dataStore;
  final AuthenticationApi authenticationApi;

  const ProfilePage({Key key, this.dataStore, this.authenticationApi})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String get _fullName => _fullNameController.text;

  String get _phoneNumber => _phoneNumberController.text;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  String get _newPassword => _newPasswordController.text;

  bool _obscureText = true;
  bool _isLoading = false;
  bool _showResetPasswordForm = false;
  bool _showUpdateDetailsForm = false;

  void _toggleUpdateDetailsFormType() {
    setState(() {
      _showResetPasswordForm = false;
      _showUpdateDetailsForm = !_showUpdateDetailsForm;
    });
    _fullNameController.clear();
    _phoneNumberController.clear();
  }

  void _toggleResetPasswordFormType() {
    setState(() {
      _showUpdateDetailsForm = false;

      _showResetPasswordForm = !_showResetPasswordForm;
    });
    _newPasswordController.clear();
    _confirmNewPasswordController.clear();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();

    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordField() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final deleteAccountDialog = await showAlertDialog(context,
          title: 'Delete Account',
          description: 'Are you sure you want to delete your account?',
          cancelBtn: 'Cancel',
          actionBtn: 'Delete');
      if (deleteAccountDialog == true) {
        await widget.dataStore.deleteUserInformation(
            uid: widget.authenticationApi.currentUser.uid);
        await widget.authenticationApi.deleteUserAccount();
        await widget.authenticationApi.logOut();
      }
    } on FirebaseAuthException catch (e) {
      showAlertDialog(context,
          title: 'Account deletion failed',
          description: e.message,
          actionBtn: 'OK');
    } finally {
      if (this.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _submitToUpdateUserInformation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _updateUserInformation(_fullName, _phoneNumber);
    } on FirebaseAuthException catch (e) {
      showAlertDialog(context,
          title: 'Information update failed',
          description: e.message,
          actionBtn: 'OK');
    } finally {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _showUpdateDetailsForm = false;
        });
      }
    }
  }

  void _submitToResetPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final compromised = await isPasswordCompromised(_newPassword);
      if (compromised) {
        showAlertDialog(context,
            title: 'Password compromised',
            description:
                'The password you have chosen has been compromised choose another.',
            actionBtn: 'OK');
      } else {
        await _resetPassword(_newPassword);
      }
    } on FirebaseAuthException catch (e) {
      showAlertDialog(context,
          title: 'Password reset failed',
          description: e.message,
          actionBtn: 'OK');
    } finally {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _showUpdateDetailsForm = false;
        });
      }
    }
  }

  Future<void> _updateUserInformation(
      String fullname, String phoneNumber) async {
    await widget.dataStore.updateUserInformation(
        user: new NfkicksUser(fullName: fullname, phoneNumber: phoneNumber),
        uid: widget.authenticationApi.currentUser.uid);
    await showAlertDialog(context,
        title: 'User details have been updated',
        description: 'Your information has been updated',
        actionBtn: 'OK');
  }

  Future<void> _resetPassword(String newPassword) async {
    await widget.authenticationApi.resetCurrentUserPassword(newPassword);
    await widget.authenticationApi.logOut();
    await showAlertDialog(context,
        title: 'Password Reset',
        description: 'Your password has been reset, please login again',
        actionBtn: 'OK');
    Navigator.pop(context);
  }

  Widget _updateUserInformationFormFields() {
    if (_showUpdateDetailsForm) {
      final fullNameValidator = MultiValidator([
        RequiredValidator(errorText: 'Full-name field is required'),
        MinLengthValidator(1,
            errorText: 'Please enter a name longer than one character'),
        MaxLengthValidator(127,
            errorText: 'Your full-name must be under 127 character long'),
      ]);

      final phoneNumberValidator = MultiValidator([
        RequiredValidator(errorText: 'Phone number field is required'),
        MinLengthValidator(5, errorText: 'Please enter a valid phone number'),
        MaxLengthValidator(10, errorText: 'Please enter a valid phone number'),
        PatternValidator(r'(^\s*\(?\s*\d{1,4}\s*\)?\s*[\d\s]{5,10}\s*$)',
            errorText: 'Please enter a valid phone number')
      ]);

      return Form(
        key: _formKey,
        child: Column(
          children: <TextFormField>[
            TextFormField(
              validator: fullNameValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _fullNameController,
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.black,
                labelText: 'New Full-Name',
                hintText: 'full name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusColor: Colors.black,
              ),
              cursorColor: Colors.black,
            ),
            TextFormField(
              validator: phoneNumberValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _phoneNumberController,
              style: TextStyle(color: Colors.black, fontSize: 16),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.black,
                labelText: 'New Phone Number',
                hintText: 'phone number',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusColor: Colors.black,
              ),
              cursorColor: Colors.black,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _resetPasswordFormFields() {
    if (_showResetPasswordForm) {
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
              validator: passwordValidator,
              controller: _newPasswordController,
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.black,
                labelText: 'New Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    _togglePasswordField();
                  },
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.black,
                  ),
                ),
                hintText: 'new password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusColor: Colors.black,
              ),
              cursorColor: Colors.black,
              obscureText: _obscureText,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value != _newPassword) {
                  return "Passwords must match!";
                }
                return null;
              },
              controller: _confirmNewPasswordController,
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 16),
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.black,
                labelText: 'Confirm New Password',
                hintText: 'confirm your new password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusColor: Colors.black,
              ),
              cursorColor: Colors.black,
              obscureText: _obscureText,
            ),
          ],
        ),
      );
    } else {
      return Container();
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Account",
          style: GoogleFonts.permanentMarker(),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildUserDetails(
                databaseApi: widget.dataStore,
                authenticationApi: widget.authenticationApi,
                toggleFormField: () => _toggleUpdateDetailsFormType(),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _showUpdateDetailsForm
                      ? _updateUserInformationFormFields()
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  _showUpdateDetailsForm
                      ? Container()
                      : OutlineButton(
                          borderSide: BorderSide(color: Colors.black),
                          onPressed: () => _toggleResetPasswordFormType(),
                          child: Text(
                            "Reset Password".toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  _showResetPasswordForm
                      ? _resetPasswordFormFields()
                      : Container(),
                  _showResetPasswordForm
                      ? RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => _formKey.currentState.validate()
                              ? _submitToResetPassword()
                              : null,
                          child: Text(
                            "submit".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : _showUpdateDetailsForm
                          ? RaisedButton(
                              color: Colors.redAccent,
                              onPressed: () => _formKey.currentState.validate()
                                  ? _submitToUpdateUserInformation()
                                  : null,
                              child: Text(
                                "submit".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : RaisedButton(
                              color: Colors.redAccent,
                              onPressed: () =>
                                  _showDeleteAccountDialog(context),
                              child: Text(
                                "Delete Account".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

StreamBuilder<NfkicksUser> _buildUserDetails(
    {DatabaseApi databaseApi,
    AuthenticationApi authenticationApi,
    VoidCallback toggleFormField}) {
  return StreamBuilder<NfkicksUser>(
    stream:
        databaseApi.getUserInformation(uid: authenticationApi.currentUser.uid),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasError) {
        print("Errors: ${snapshot.error}");
        return kLoadingNoLogo;
      }
      if (!snapshot.hasData) {
        return kLoadingNoLogo;
      }
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => {},
              child: userImage(snapshot.data.image.toString().isNotEmpty
                  ? snapshot.data.image
                  : "https://firebasestorage.googleapis.com/v0/b/nfkicks-35620.appspot.com/o/avatar.jpg?alt=media&token=a95e1f32-eb65-49cd-8e30-3f26693f4d2f"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            snapshot.data.fullName.toString().isNotEmpty
                                ? snapshot.data.fullName
                                : "Placeholder Name",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data.email.toString().isNotEmpty
                              ? snapshot.data.email
                              : "LacreshaB@gmail.com",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data.phoneNumber.toString().isNotEmpty
                              ? snapshot.data.phoneNumber
                              : "Placeholder phone number",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.deepOrangeAccent,
                      onPressed: toggleFormField,
                      child: Text(
                        "Update info...".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Container userImage(String image) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image))),
  );
}
