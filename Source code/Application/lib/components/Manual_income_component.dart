import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomeComponent extends StatefulWidget {
  final firebaseInstance;
  IncomeComponent(this.firebaseInstance);
  @override
  _IncomeComponentState createState() =>
      _IncomeComponentState(firebaseInstance);
}

class _IncomeComponentState extends State<IncomeComponent> {
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  // final _walletID;
  final firebaseInstance;
  _IncomeComponentState(this.firebaseInstance);
  double amount = 0;
  String note = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Amount",
                style: TextStyle(color: Color(0xffB58FE7), fontSize: 16.sp),
                textAlign: TextAlign.left),
          ),
          TextField(
            maxLength: 7,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(22.0.r)),
                borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(22.0.r)),
                borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5.w),
              ),
            ),
            style: TextStyle(fontSize: 25.sp),
            onChanged: (String str) {
              setState(() {
                amount = double.parse(str);
              });
            },
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Note",
              style: TextStyle(color: Color(0xffC88EC5), fontSize: 16.sp),
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffC88EC5), width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0.r)),
                borderSide: BorderSide(color: Color(0xffC88EC5), width: 1.5.w),
              ),
            ),
            style: TextStyle(fontSize: 20.sp),
            onChanged: (String str) {
              setState(() {
                note = str;
              });
            },
          ),
          SizedBox(height: 40.h),
          GestureDetector(
            onTap: () {
              _fireStore
                  .collection('users')
                  .doc(uid)
                  .collection('wallet')
                  .doc(firebaseInstance.walletID.toString())
                  .collection('transaction')
                  .add({
                'class': 'income',
                'cost': amount ?? 0,
                'createdOn': FieldValue.serverTimestamp(),
                'name': note,
                'type': 'income'
              });

              CollectionReference wallet = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('wallet');
              wallet
                  .doc(firebaseInstance.walletID.toString())
                  .update({'money': FieldValue.increment(amount)})
                  .then((value) => print("Wallet Updated"))
                  .catchError(
                      (error) => print("Failed to update wallet: $error"));
              var counter = 0;
              Navigator.popUntil(context, (route) {
                return counter++ == 2;
              });
            },
            child: Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  color: Color(0xffDB8EA7)),
              child: Center(
                child: Text(
                  "ADD NEW TRANSACTION",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
