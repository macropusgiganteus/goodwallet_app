import 'package:flutter/material.dart';
import 'package:goodwallet_app/components/Calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class History extends StatefulWidget {
  final index;
  final firebaseInstance;
  History(this.index, this.firebaseInstance);
  @override
  _HistoryState createState() => _HistoryState(index, firebaseInstance);
}

class _HistoryState extends State<History> {
  final index;
  final firebaseInstance;
  _HistoryState(this.index, this.firebaseInstance);
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25.w, top: 19.h),
                      child: Text(
                        "HISTORY",
                        style: TextStyle(
                            letterSpacing: 0.9,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 25.0.w, top: 19.h),
                        child: Text(
                          "See less",
                          style: TextStyle(
                              fontSize: 12.sp,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
                Calendar(firebaseInstance.walletID),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
