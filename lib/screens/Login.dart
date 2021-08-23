import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'createaccount.dart';
import '../util/Authentication.dart';

class Login extends StatefulWidget {
  Login() {
    Firebase.initializeApp();
  }
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _userid;
  var _message;
  var _enabled = false;
  var idController = TextEditingController();
  var pwController = TextEditingController();
  Authentication? auth;
  @override

  void initState(){
    auth = Authentication();
    _userid = null;
    _message = "";
    _enabled = false;
    idController.addListener(check);
    pwController.addListener(check);
    super.initState();
  }
  @override
  void dispose(){
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Meeting Scheduler",
            style: GoogleFonts.pacifico(
              fontSize: 30,
              color: Colors.black,
            ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: 'ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
              ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pwController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top : 8.0, bottom : 8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("$_message",
                  style: GoogleFonts.nanumGothic(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: Colors.blue[100],
                  ),onPressed: _enabled ? submit : null,
                      child: Text("로그인",
                        style: GoogleFonts.nanumGothic(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[100],
                      ),
                      onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateAccount())
                    );
                    setState(() {
                      _message = '';
                    });
                  },
                      child: Text("회원가입",
                        style: GoogleFonts.nanumGothic(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void check() {
    if (idController.text != "" && pwController.text != "") {
      setState(() {
        _enabled = true;
      });
    }
  }

  Future submit() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      _userid = await auth!.login(idController.text, pwController.text);
      if (_userid != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Home(uid : _userid))
        );
        setState(() {
          _message = '';
        });
      }
      return _userid;
    } catch(e){
      if(e.toString().contains('corresponding')) {
        setState(() {
          _message = '존재하지 않는 계정입니다';
        });
      } else if(e.toString().contains('password is invalid')){
        setState(() {
          _message = '비밀번호를 확인해주세요';
        });
      } else {
        setState(() {
          _message = e.toString();
        });
      }
    }
  }
}

