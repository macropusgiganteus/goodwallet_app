import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Login_popup.dart';
import 'package:goodwallet_app/Wallet.dart';
import 'package:goodwallet_app/components/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignIn extends StatefulWidget {
  final popUpSignIn;
  SignIn(this.popUpSignIn);
  @override
  _SignInState createState() => _SignInState(popUpSignIn);
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _controller2;
  var popUpSignIn;
  _SignInState(this.popUpSignIn);
  double signIn = 0;
  double signUp = 1;
  String email;
  String password;
  final _text = TextEditingController();
  final _text2 = TextEditingController();
  bool _validate = false;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _validate = false;
    setState(() {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _controller2 = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      if (popUpSignIn == 0) {
        signIn = 0;
        signUp = 1;
        _controller.forward();
      } else {
        signIn = 1;
        signUp = 0;
        _controller2.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: _screenHeight,
            width: _screenWidth,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50.h, bottom: 20.h),
                  child: Hero(
                    tag: 'pop_up',
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('images/Small_Logo.svg')),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 0.1.sw,
                      right: 0.1.sw,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(71.r),
                        topRight: Radius.circular(71.r),
                      ),
                      color: Color(0xFFF4F6FF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: 'Login-button',
                          child: Padding(
                            padding: EdgeInsets.only(top: 25.0.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  height: 47.h,
                                  minWidth: 114.5.w,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xff8C35B1),
                                        width: 1.5.w,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(24.0.r),
                                  ),
                                  padding: EdgeInsets.all(6.w),
                                  onPressed: () {
                                    setState(() {
                                      _controller2.forward();
                                      _controller.reverse();
                                      signIn = 1;
                                      signUp = 0;
                                    });
                                  },
                                  color: signIn == 1
                                      ? Color(0xff8C35B1)
                                      : Color(0xFFF4F6FF),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  textColor: signIn == 1
                                      ? Color(0xFFF4F6FF)
                                      : Color(0xff8C35B1),
                                ),
                                SizedBox(width: 14.sp),
                                FlatButton(
                                  height: 47.h,
                                  minWidth: 114.5.w,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Color(0xffB58FE7),
                                          width: 1.5.w,
                                          style: BorderStyle.solid),
                                      borderRadius:
                                          BorderRadius.circular(24.0.r)),
                                  padding: EdgeInsets.all(6.w),
                                  onPressed: () {
                                    setState(() {
                                      _controller.forward().orCancel;
                                      _controller2.reverse();
                                      signIn = 0;
                                      signUp = 1;
                                    });
                                  },
                                  color: signUp == 1
                                      ? Color(0xffB58FE7)
                                      : Color(0xFFF4F6FF),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  textColor: signUp == 1
                                      ? Color(0xFFF4F6FF)
                                      : Color(0xffB58FE7),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            SlideTransition(
                              position: Tween<Offset>(
                                      begin: Offset.zero, end: Offset(-1.5, 0))
                                  .animate(CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeIn,
                              )),
                              child: IgnorePointer(
                                ignoring: signIn == 1 ? false : true,
                                child: AnimatedOpacity(
                                  opacity: signIn,
                                  duration: Duration(milliseconds: 500),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 14.0.w, bottom: 10.0.h),
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
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: _text,
                                          decoration: InputDecoration(
                                            errorText: _validate
                                                ? 'Value Can\'t Be Empty'
                                                : null,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10.w),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Color(0xffB58FE7),
                                                  width: 1.5.w),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Color(0xffB58FE7),
                                                  width: 1.5.w),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Colors.red[100],
                                                  width: 1.5.w),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Colors.red[100],
                                                  width: 1.5.w),
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
                                            padding: EdgeInsets.only(
                                                left: 14.0.w,
                                                bottom: 5.0.h,
                                                top: 5.h),
                                            child: Text(
                                              "Password",
                                              style: TextStyle(
                                                  color: Color(0xff8C35B1),
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          cursorColor: Colors.black,
                                          keyboardType: TextInputType.text,
                                          controller: _text2,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            errorText: _validate
                                                ? 'Value Can\'t Be Empty'
                                                : null,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10.w),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Color(0xffB58FE7),
                                                  width: 1.5.w),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Color(0xffB58FE7),
                                                  width: 1.5.w),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Colors.red[100],
                                                  width: 1.5.w),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0.r)),
                                              borderSide: BorderSide(
                                                  color: Colors.red[100],
                                                  width: 1.5.w),
                                            ),
                                          ),
                                          style: TextStyle(fontSize: 16.sp),
                                          onChanged: (String str) {
                                            setState(() {
                                              password = str;
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _text.text.isEmpty ||
                                                      _text2.text.isEmpty
                                                  ? _validate = true
                                                  : _validate = false;
                                            });
                                            if (email == null ||
                                                password == null) {
                                            } else {
                                              try {
                                                final user = await _auth
                                                    .signInWithEmailAndPassword(
                                                        email: email,
                                                        password: password);
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setStringList(
                                                    'user', [email, password]);
                                                if (user != null) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return Wallet();
                                                  }));
                                                } else {
                                                  showAlertDialog(
                                                      context,
                                                      'Error',
                                                      "Check your email or password and try again.");
                                                }
                                              } catch (e) {
                                                print(e);
                                                showAlertDialog(
                                                    context,
                                                    'Error',
                                                    "Check your email or password and try again.");
                                              }
                                            }
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(top: 0.03.sh),
                                            width: double.infinity,
                                            height: 0.075.sh,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                color: Color(0xffA890FE)),
                                            child: Stack(
                                              children: [
                                                Center(
                                                    child: Text(
                                                  "Sign In",
                                                  style: TextStyle(
                                                      fontSize: 16.sp),
                                                )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 26.0.w),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      size: 30.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FlatButton(
                                              onPressed: () {
                                                forgotPasswordBox(context);
                                              },
                                              child: Text(
                                                "Forgot password?",
                                                style: TextStyle(
                                                    color: Color(0xff8C35B1),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            loginWithFacebook(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 0.02.sh, bottom: 0.02.sh),
                                            width: double.infinity,
                                            height: 0.07.sh,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                color: Color(0xffDB8EA7)),
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0.w),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: SvgPicture.asset(
                                                      'images/facebook.svg',
                                                      width: 35.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                    child: Text(
                                                  "Continue with facebook",
                                                  style: TextStyle(
                                                      fontSize: 16.sp),
                                                )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 26.0.w),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      size: 30.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 50.h)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SlideTransition(
                              position: Tween<Offset>(
                                      begin: Offset.zero, end: Offset(1.5, 0))
                                  .animate(CurvedAnimation(
                                parent: _controller2,
                                curve: Curves.easeIn,
                              )),
                              child: IgnorePointer(
                                ignoring: signUp == 1 ? false : true,
                                child: AnimatedOpacity(
                                  opacity: signUp,
                                  duration: Duration(milliseconds: 500),
                                  child: SignUp(),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future loginWithFacebook(BuildContext context) async {
    FacebookLogin facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    FacebookLoginResult result =
        await facebookLogin.logIn(['email', "public_profile"]);
    final _fireStore = FirebaseFirestore.instance;
    String token = result.accessToken.token;
    print("Access token = $token");
    var user = await _auth
        .signInWithCredential(FacebookAuthProvider.credential(token));
    final email = _auth.currentUser.email;
    final uid = _auth.currentUser.uid;
    final id = _fireStore.collection('users').doc(uid).get();
    if (id != null) {
      _fireStore.collection('users').doc(uid).set({"uid": uid, 'email': email});
    }
    if (user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      print(prefs.get('token'));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Wallet();
      }));
    } else {
      showAlertDialog(
          context, 'Error', "Check your email or password and try again.");
    } // after success, navigate to home.
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

forgotPasswordBox(BuildContext context) {
  String email;
  final _auth = FirebaseAuth.instance;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Forgot password?",
          style: TextStyle(color: Color(0xff8C35B1)),
        ),
        content: Text("Enter email for reset your password"),
        actions: [
          Center(
            child: SizedBox(
                width: 0.7.sw,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                    ),
                    labelText: 'Email Address',
                  ),
                  onChanged: (String str) {
                    email = str;
                  },
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: TextStyle(color: Color(0xffB58FE7)))),
                FlatButton(
                    onPressed: () async {
                      try {
                        await _auth.sendPasswordResetEmail(email: email);
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop();
                      showAlertDialog(context, "Email has been sent",
                          "check your email to reset password.");
                    },
                    child: Text('Send Email',
                        style: TextStyle(color: Color(0xffB58FE7))))
              ],
            ),
          )
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.r))),
      );
    },
  );
}
