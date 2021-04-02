import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodwallet_app/components/walletSelector.dart';
import 'package:goodwallet_app/classes/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferComponent extends StatefulWidget {
  final firebaseInstance;
  TransferComponent(this.firebaseInstance);
  @override
  _TransferComponentState createState() =>
      _TransferComponentState(firebaseInstance);
}

class _TransferComponentState extends State<TransferComponent> {
  // final _walletID;
  final firebaseInstance;
  String note;
  double amount;
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  var initialWallet;
  var targetWallet;
  _TransferComponentState(this.firebaseInstance);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialWallet = new Transactions();
    targetWallet = new Transactions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "From",
                      style:
                          TextStyle(color: Color(0xffA890FE), fontSize: 16.sp),
                    ),
                    // WalletSelector(initialWallet),
                    WalletSelector(initialWallet)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h),
                child: SvgPicture.asset(
                  "./images/transferLogo.svg",
                  color: Color(0xffA890FE),
                  width: 25.w,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "To",
                      style:
                          TextStyle(color: Color(0xffA890FE), fontSize: 16.sp),
                    ),
                    WalletSelector(targetWallet),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
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
          SizedBox(height: 20.h),
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
              //initial wallet
              _fireStore
                  .collection('users')
                  .doc(uid)
                  .collection('wallet')
                  .doc(firebaseInstance.walletID.toString())
                  .collection('transaction')
                  .add({
                'class': 'transfer',
                'cost': -amount ?? 0,
                'createdOn': FieldValue.serverTimestamp(),
                'name': note,
                'type': 'transfer'
              });

              //target wallet
              _fireStore
                  .collection('users')
                  .doc(uid)
                  .collection('wallet')
                  .doc(targetWallet.targetWalletID)
                  .collection('transaction')
                  .add({
                'class': 'transfer',
                'cost': amount ?? 0,
                'createdOn': FieldValue.serverTimestamp(),
                'name': note,
                'type': 'transfer'
              });

              //update wallet
              CollectionReference wallet = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('wallet');
              wallet
                  .doc(firebaseInstance.walletID.toString())
                  .update({'money': FieldValue.increment(-amount)})
                  .then((value) => print("Wallet Updated"))
                  .catchError(
                      (error) => print("Failed to update wallet: $error"));

              wallet
                  .doc(targetWallet.targetWalletID.toString())
                  .update({'money': FieldValue.increment(amount)})
                  .then((value) => print("Wallet Updated"))
                  .catchError(
                      (error) => print("Failed to update wallet: $error"));

              // navigate back
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
          ),
        ],
      ),
    );
  }
}
