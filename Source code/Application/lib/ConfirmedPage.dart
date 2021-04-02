import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Voice_Input.dart';
import 'package:goodwallet_app/CreateWallet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmedMainPage extends StatelessWidget {
  final index;
  ConfirmedMainPage(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Background Gradient Color
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SafeArea(child: ConfirmedPage(index)),
      ),
    );
  }
}

class ConfirmedPage extends StatefulWidget {
  final index;
  ConfirmedPage(this.index);
  @override
  _ConfirmedPageState createState() => _ConfirmedPageState(index);
}

class _ConfirmedPageState extends State<ConfirmedPage> {
  final index;
  _ConfirmedPageState(this.index);
  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 171.h,
          ),
          Container(
            child: SvgPicture.asset(
              'images/check-mark.svg',
              height: 169.0.h,
              width: 169.0.h,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 37.h),
            child: Text('This item has been saved'),
          ),
          SizedBox(
            height: 100.h,
          ),
          Container(
            alignment: Alignment.center,
            height: 51.h,
            width: 268.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, width: 5.0.w, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(27.0.r)),
            ),
            child: Listener(
              onPointerDown: (detail) {
                print('go to add transaction page');
                var count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
              },
              child: Text(
                'ADD NEW TRANSACTION',
                style: TextStyle(color: Color(0xff6A2388)),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 16.h),
            height: 51.h,
            width: 268.w,
            decoration: BoxDecoration(
              color: Color(0xff580F77),
              border: Border.all(
                  color: Color(0xff580F77),
                  width: 5.0.w,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(27.0.r)),
            ),
            child: Listener(
              onPointerDown: (detail) {
                print('going to transaction lists of wallet' + index);
                var count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 3;
                });
              },
              child: Text(
                'SHOW TRANSACTIONS',
              ),
            ),
          )
        ],
      ),
    );
  }
}
