import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/main.dart';
import 'Login_popup.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goodwallet_app/Wallet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  String token = '';
  String email = '';
  String password = '';
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> userList = prefs.getStringList('user');
    final String userToken = prefs.get('token');
    print('userToken is : ');
    print(userToken);
    print('user list is : ');
    print(userList ?? 'null');
    if (userList != null) {
      setState(() {
        email = userList[0];
        password = userList[1];
      });
      return;
    } else if (userToken != null) {
      setState(() {
        token = userToken;
      });
      return;
    }
  }

  @override
  void initState() {
    autoLogIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 252.5.h),
            child:
                Hero(tag: 'pop_up', child: SvgPicture.asset('images/Logo.svg')),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 38.h),
            child: GestureDetector(
              onTap: () {
                if (email == '' && token == '') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginPopup();
                  }));
                } else if (token != '') {
                  final user = _auth.signInWithCredential(
                      FacebookAuthProvider.credential(token));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Wallet();
                  }));
                } else {
                  final user = _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Wallet();
                  }));
                }
              },
              child: Column(
                children: <Widget>[
                  Text(
                    "TOUCH\nTO START",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
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
