import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/Authentication.dart';
import '../model/user.dart';

class CreateAccount extends StatefulWidget {

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var _userId;
  String message = "";
  var _email;
  var _password;
  var _enabled = false;

  var nameController  = TextEditingController();
  var nickController  = TextEditingController();
  var emailController  = TextEditingController();
  var passwordController  = TextEditingController();

  late Authentication auth;
  @override
  void initState(){
    _enabled = false;
    auth = Authentication();
    nameController.addListener(check);
    nickController.addListener(check);
    emailController.addListener(check);
    passwordController.addListener(check);

    super.initState();
  }
  @override
  void dispose(){
    nameController.dispose();
    nickController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Name"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Nickname"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nickController,
                decoration: InputDecoration(
                  hintText: 'Nickname',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Email(ID)"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Password"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$message",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: _enabled ? submit : null,
                    child: Text("회원가입"),
                    style: ElevatedButton.styleFrom(
                      primary:  _enabled ? Colors.blue : Colors.grey,
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future submit() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      _userId = await auth.signUp(emailController.text, passwordController.text);
      Users user = Users(null,_userId, nickController.text, nameController.text, [], [], []);
      var result  = db.collection('Users').doc('$_userId').set(user.toMap());
      Navigator.pop(context);
      return result;
    } catch(e) {
      setState(() {
        message = e.toString();
      });
    }
  }

  void check() {
    if (nameController.text != "" && nickController.text != ""  && emailController.text != ""  && passwordController.text != ""  ) {
      setState(() {
        _enabled = true;
      });
    }
  }
}
