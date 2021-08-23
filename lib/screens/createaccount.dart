import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../util/Authentication.dart';
import '../model/user.dart';

class CreateAccount extends StatefulWidget {

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _userId;
  String message = "";
  String confirmMessage = "";
  String nickCheckMessage = "";
  bool _enabled = false;
  bool isNickChecked = false;
  bool passwordChecked = false;

  var nameController  = TextEditingController();
  var nickController  = TextEditingController();
  var emailController  = TextEditingController();
  var passwordController  = TextEditingController();
  var confirmPasswordController  = TextEditingController();

  late Authentication auth;
  @override
  void initState(){
    _enabled = false;
    isNickChecked = false;
    auth = Authentication();
    nameController.addListener(check);
    nickController.addListener(check);
    emailController.addListener(check);
    passwordController.addListener(check);
    confirmPasswordController.addListener(check);

    passwordController.addListener(checkPassword);
    confirmPasswordController.addListener(checkPassword);

    emailController.addListener(messageFormatter);
    super.initState();
  }
  @override
  void dispose(){
    nameController.dispose();
    nickController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Sign up",
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("이름",
                    style: GoogleFonts.nanumGothic(
                      fontWeight : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '이름',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("닉네임",
                style: GoogleFonts.nanumGothic(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left : 8.0, top : 8.0, bottom : 8.0, right : 10.0),
                      child: TextField(
                        enabled: isNickChecked ? false : true,
                        controller: nickController,
                        decoration: InputDecoration(
                          hintText: '닉네임',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal[100],
                        ),
                        onPressed : (){
                          checkNickName(nickController.text);
                        }
                        ,
                        child: Text("중복 검사",
                          style: GoogleFonts.nanumGothic(
                            color : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(nickCheckMessage,
                style: GoogleFonts.nanumGothic(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isNickChecked ? Colors.green : Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("아이디(이메일)",
                style: GoogleFonts.nanumGothic(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("비밀번호",
                style: GoogleFonts.nanumGothic(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: '비밀번호는 6자리 이상으로 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("비밀번호 확인",
                style: GoogleFonts.nanumGothic(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$confirmMessage",
                style: GoogleFonts.nanumGothic(
                  color: passwordChecked ? Colors.green : Colors.red,
                  fontSize : 12,
                  fontWeight : FontWeight.bold,
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
                      primary:  Colors.teal[100],
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
      if(e.toString().contains('badly formatted')) {
        setState(() {
          message = '이메일 형식이 잘못 되었습니다.';
        });
      } else if(e.toString().contains('already in use')){
        setState(() {
          message = '이미 존재하는 이메일 입니다.';
        });
      }
    }
  }

  check() {
    if (nameController.text != ""
        && nickController.text != ""
        && emailController.text != ""
        && passwordController.text != ""
        && confirmPasswordController.text != ""
        && isNickChecked == true
        && passwordChecked == true
    ) {
      setState(() {
        _enabled = true;
      });
    } else {
      setState(() {
        _enabled = false;
      });
    }
  }

  checkPassword() {
    if(passwordController.text != ""
        && confirmPasswordController.text != ""
          && passwordController.text != confirmPasswordController.text){
      setState(() {
        confirmMessage = "비밀번호가 일치하지 않습니다";
        passwordChecked = false;
      });
    }
    if(passwordController.text != ""
        && confirmPasswordController.text != ""
        && passwordController.text == confirmPasswordController.text){
      setState(() {
        confirmMessage = "비밀번호가 일치합니다";
        passwordChecked = true;
      });
      check();
    }
  }

  checkNickName(String nick) async{
    var temp;
    List totalNick = [];
    await db.collection('Users').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        temp = doc.data();
        totalNick.add(temp['nickname']);
      });
    });
    if(nick == ''){
      setState(() {
        isNickChecked = false;
        nickCheckMessage = "닉네임을 입력해주세요";
      });
    } else if(totalNick.contains(nick)) {
      setState(() {
        isNickChecked = false;
        nickCheckMessage = "이미 존재하는 닉네임 입니다";
      });
    } else {
      setState(() {
        isNickChecked = true;
        nickCheckMessage = "사용 가능한 닉네임 입니다";
        check();
      });
    }
  }

  messageFormatter() {
    setState(() {
      message = '';
    });
  }
}
