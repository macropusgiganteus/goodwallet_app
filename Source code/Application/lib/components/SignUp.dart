import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goodwallet_app/Wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  String userName;
  String email;
  String password;
  String confirm;
  final _text = TextEditingController();
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    _validate = false;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 14.0.w, bottom: 3.0.h, top: 10.0.h),
              child: Text(
                "Email",
                style: TextStyle(
                    color: Color(0xff8C35B1),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Colors.red[100], width: 1.5.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(color: Colors.red[100], width: 1.5.w),
              ),
            ),
            style: TextStyle(fontSize: 16.sp),
            onChanged: (String str) {
              setState(() {
                email = str;
              });
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 14.0.w, bottom: 3.0.h, top: 10.0.h),
              child: Text(
                "Password",
                style: TextStyle(
                    color: Color(0xffAE73CA),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.r)),
                borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Colors.red[100], width: 1.5.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Colors.red[100], width: 1.5.w),
              ),
            ),
            style: TextStyle(fontSize: 16.sp),
            onChanged: (String str) {
              setState(() {
                password = str;
              });
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 14.0.w, bottom: 3.0.h, top: 10.0.h),
              child: Text(
                "Confirm Password",
                style: TextStyle(
                    color: Color(0xffC98FC6),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffC88EC5), width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffC88EC5), width: 1.5.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Colors.red[100], width: 1.5.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Colors.red[100], width: 1.5.w),
              ),
            ),
            style: TextStyle(fontSize: 16.sp),
            onChanged: (String str) {
              setState(() {
                confirm = str;
              });
            },
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                email == null || password == null || confirm == null
                    ? _validate = true
                    : _validate = false;
              });

              if (password == confirm) {
                if (password.length < 6) {
                  showAlertDialog(context, "Weak Password",
                      "Password should be at least 6 characters please try again.");
                }
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    final _fireStore = FirebaseFirestore.instance;
                    var uid = _auth.currentUser.uid;
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setStringList('user', [email, password]);
                    _fireStore
                        .collection('users')
                        .doc(uid)
                        .set({"uid": uid, "email": email});
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Wallet()));
                  }
                } catch (e) {
                  print(e);
                  showAlertDialog(context, "Check your email address",
                      "Please check your email address or password and try again.");
                }
              } else {
                showAlertDialog(context, "Wrong password",
                    "Your password didn't match please try again.");
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 0.03.sh),
              width: double.infinity,
              height: 0.075.sh,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Color(0xffDB8EA7)),
              child: Stack(
                children: [
                  Center(
                      child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16.sp),
                  )),
                  Padding(
                    padding: EdgeInsets.only(right: 26.0.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 30.w,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, titleText, contentText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          titleText,
          style: TextStyle(color: Color(0xff8C35B1)),
        ),
        content: Text(contentText),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Color(0xffB58FE7))))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.r))),
      );
    },
  );
}
