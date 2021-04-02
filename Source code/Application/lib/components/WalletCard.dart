import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletCard extends StatelessWidget {
  final String name;
  final money;
  WalletCard(this.name, this.money);
  @override
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(bottom: 5.h),
        width: 309.w,
        height: 147.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(34.r)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Text(
                  name,
                  style: TextStyle(
                      color: Color(0xffA1A1A1),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300.0.w,
                    maxHeight: 54.h,
                  ),
                  child: AutoSizeText(
                    money.toStringAsFixed(2).replaceAllMapped(reg, mathFunc),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 41.0.sp,
                        color: Color(0xffA890FE),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: Text(
                  "BAHT",
                  style: TextStyle(
                      color: Color(0xffA890FE),
                      fontSize: 14.sp,
                      letterSpacing: 0.42,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]));
  }
}
