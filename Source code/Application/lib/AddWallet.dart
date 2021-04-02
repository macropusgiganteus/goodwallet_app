import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Wallet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWallet extends StatefulWidget {
  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  String name = "";
  double money = 0;
  FocusNode focusNode = FocusNode();
  FocusNode focusName = FocusNode();
  String hintNumber = '0';
  String hintText = 'wallet name';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusName.addListener(() {
      if (focusName.hasFocus) {
        hintText = '';
      } else {
        hintText = 'wallet name';
      }
      setState(() {});
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintNumber = '';
      } else {
        hintNumber = '0';
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Header(),
              Container(
                height: 252.h,
                width: 0.68.sw,
                margin: EdgeInsets.only(top: 0.08.sh),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34.r),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 214.w,
                      child: TextField(
                        maxLength: 15,
                        focusNode: focusName,
                        decoration: new InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                                color: Color(0xffA1A1A1), fontSize: 22.sp),
                            counterText: ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.sp, color: Color(0xffA1A1A1)),
                        onChanged: (String str) {
                          setState(() {
                            name = str;
                          });
                        },
                      ),
                    ),
                    TextField(
                      maxLength: 7,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15.w, bottom: 11.h, top: 11.h, right: 15.w),
                          hintText: hintNumber,
                          hintStyle: TextStyle(
                              color: Color(0xffB58FE7), fontSize: 50.sp)),
                      focusNode: focusNode,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color(0xffB58FE7), fontSize: 50.sp),
                      onChanged: (String n) {
                        setState(() {
                          money = double.parse(n);
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25.h),
                      child: Text("BAHT",
                          style: TextStyle(
                            color: Color(0xffB58FE7),
                            fontSize: 16.sp,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _fireStore
                      .collection('users')
                      .doc(uid)
                      .collection('wallet')
                      .add({
                    'name': name == "" ? 'wallet' : name,
                    'money': money,
                    'createdOn': Timestamp.now(),
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  height: 51.h,
                  width: 0.68.sw,
                  margin: EdgeInsets.symmetric(vertical: 40.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31.r),
                      color: Color(0xff6A2388)),
                  child: Center(
                    child: Text(
                      "Add new wallet",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
