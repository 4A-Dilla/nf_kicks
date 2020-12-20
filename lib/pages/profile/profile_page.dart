import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';

class ProfilePage extends StatefulWidget {
  final DatabaseApi dataStore;

  const ProfilePage({Key key, this.dataStore}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showResetPasswordForm = false;

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final deleteAccountDialog = await showAlertDialog(context,
        title: 'Delete Account',
        description: 'Are you sure you want to delete your account?',
        cancelBtn: 'Cancel',
        actionBtn: 'Delete');
    if (deleteAccountDialog == true) {
      print("Delete Account!");
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: userImage(
                        "https://images.unsplash.com/photo-1608310554442-c6bca9b219fb?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=636&q=80"),
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
                                Text(
                                  "Lacresha Baynham",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "LacreshaB@gmail.com",
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
                                  "318-344-6321",
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
                              onPressed: () {},
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
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.black),
                    onPressed: () => setState(
                        () => showResetPasswordForm = !showResetPasswordForm),
                    child: Text(
                      "Reset Password".toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  showResetPasswordForm ? TextFormField() : Container(),
                  RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () => _showDeleteAccountDialog(context),
                    child: Text(
                      "Delete Account".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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

Container userImage(String image) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://images.unsplash.com/photo-1608310554442-c6bca9b219fb?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=636&q=80"))),
  );
}
