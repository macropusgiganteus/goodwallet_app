import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Wallet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget expenseClass(type, title, {color = 0xff8C35B1}) {
  return Column(
    children: [
      Container(
        height: 33.h,
        child: SvgPicture.asset(
          './images/$type.svg',
          color: Color(color),
          fit: BoxFit.scaleDown,
        ),
      ),
      SizedBox(height: 3.h),
      Text(
        title,
        style: TextStyle(color: Color(color), fontSize: 6.5.sp),
      )
    ],
  );
}

class ExpenseComponent extends StatefulWidget {
  // final _walletID;
  final firebaseInstance;
  ExpenseComponent(this.firebaseInstance);
  @override
  _ExpenseComponentState createState() =>
      _ExpenseComponentState(firebaseInstance);
}

class _ExpenseComponentState extends State<ExpenseComponent> {
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  final firebaseInstance;
  int _class;
  double amount = 0;
  String note = '';
  _ExpenseComponentState(this.firebaseInstance);
  // var _walletID = ;

  String checkClass(x) {
    String result;
    switch (x) {
      case 1:
        result = 'entertainment';
        break;
      case 2:
        result = 'residence';
        break;
      case 3:
        result = 'household';
        break;
      case 4:
        result = 'travel';
        break;
      case 5:
        result = 'health';
        break;
      case 6:
        result = 'food';
        break;
      case 7:
        result = 'shopping';
        break;
      default:
        result = 'food';
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 1;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 1 ? 1 : 0.5,
                    child: expenseClass('Entertainment', 'Entertainment'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 2;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 2 ? 1 : 0.5,
                    child: expenseClass('Residence', 'Residence'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 3;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 3 ? 1 : 0.5,
                    child: expenseClass('Household', 'Household'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 4;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 4 ? 1 : 0.5,
                    child: expenseClass('Travel', 'Travel'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 5;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 5 ? 1 : 0.5,
                    child: expenseClass('Health', 'Health'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 6;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 6 ? 1 : 0.5,
                    child: expenseClass('Food', 'Food'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 7;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 7 ? 1 : 0.5,
                    child: expenseClass('Shopping', 'Shopping'),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
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
        SizedBox(height: 30.h),
        GestureDetector(
          onTap: () {
            _fireStore
                .collection('users')
                .doc(uid)
                .collection('wallet')
                .doc(firebaseInstance.walletID.toString())
                .collection('transaction')
                .add({
              'class': checkClass(_class),
              'cost': (amount * (-1)) ?? 0,
              'createdOn': FieldValue.serverTimestamp(),
              'name': note,
              'type': 'expense'
            });

            CollectionReference wallet = FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('wallet');
            wallet
                .doc(firebaseInstance.walletID.toString())
                .update({'money': FieldValue.increment((amount * (-1)) ?? 0)})
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
      ]),
    );
  }
}
