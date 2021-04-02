import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Wallet.dart';
import 'package:goodwallet_app/SignInPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPopup extends StatefulWidget {
  @override
  _LoginPopupState createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    var signInButton;
    return Material(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.2),
            child: Hero(
              tag: 'pop_up',
              child: SvgPicture.asset('images/Logo.svg'),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(71.r),
                  topRight: Radius.circular(71.r),
                ),
                color: Color(0xFFF4F6FF),
              ),
              height: 370.h,
              padding: EdgeInsets.fromLTRB(60.w, 0, 60.w, 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.horizontal_rule_rounded),
                      color: Color(0xffC78EC8),
                      iconSize: 60.w,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Color(0xff8C35B1),
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp,
                      fontFamily: 'HinSiliguri',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Manage your expenses in a smart way.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xff8C35B1),
                      fontFamily: 'HinSiliguri',
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(
                    height: 57.h,
                  ),
                  Hero(
                    tag: 'Login-button',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          height: 47.h,
                          minWidth: 114.5.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0.r)),
                          padding: EdgeInsets.all(6.w),
                          onPressed: () {
                            signInButton = 1;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignIn(signInButton);
                            }));
                          },
                          color: Color(0xff8C35B1),
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          textColor: Colors.white,
                        ),
                        SizedBox(width: 11.w),
                        FlatButton(
                          height: 47.h,
                          minWidth: 114.5.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0.r)),
                          padding: EdgeInsets.all(6.w),
                          onPressed: () {
                            signInButton = 0;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignIn(signInButton);
                            }));
                          },
                          color: Color(0xffB58FE7),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          textColor: Colors.white,
                        ),
                      ],
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
