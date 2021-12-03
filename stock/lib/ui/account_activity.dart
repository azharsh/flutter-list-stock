import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountActivity extends StatefulWidget {
  const AccountActivity({Key? key}) : super(key: key);

  @override
  _AccountActivityState createState() => _AccountActivityState();
}

class _AccountActivityState extends State<AccountActivity> {
  User? userData;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pop(context);
      } else {
        userData = user;
      }
    });
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 190.0,
                height: 190.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(userData?.photoURL ?? "")))),
            const SizedBox(
              height: 30,
            ),
            Text(
              userData?.email ?? "",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              userData?.displayName ?? "",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              getDate(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    checkLogin();
                  });
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ));
  }
}
