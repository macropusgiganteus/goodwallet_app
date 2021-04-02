import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 35.h, 22.5.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          Text(
            "WALLET",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.sp,
                letterSpacing: 0.66),
          ),
          SizedBox(
            width: 30.w,
          ),
        ],
      ),
    );
  }
}
