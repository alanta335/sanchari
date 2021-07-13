import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("homepage"),
        actions: [
          TextButton(
            child: Text(
              "log out",
              style: TextStyle(
                color: Color(0xFFC108F0),
              ),
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.loggedout();
            },
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.photoURL!),
          ),
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text("profile"),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
              SizedBox(height: 8),
              Text("Name :" + user.displayName!)
            ],
          )),
    );
  }
}
