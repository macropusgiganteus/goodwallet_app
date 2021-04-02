import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodwallet_app/Graph.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/components/IconSelector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransList extends StatefulWidget {
  final arg;
  final firebaseInstance;

  TransList(this.arg, this.firebaseInstance);
  @override
  _TransListState createState() => _TransListState(arg, firebaseInstance);
}

class _TransListState extends State<TransList> {
  final index;
  final firebaseInstance;
  _TransListState(this.index, this.firebaseInstance);
  final wallets = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  String name;
  String firstHalf;
  String secondHalf;
  bool isIncome;
  var income;
  var expense;
  var _start;
  var _end;
  final _formattedNumber = NumberFormat.compact().format(1000000);
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime utc = DateTime.utc(now.year, now.month, now.day);
    _start = Timestamp.fromMillisecondsSinceEpoch(
        utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
    _end = Timestamp.fromMillisecondsSinceEpoch(utc
        .add(Duration(hours: 16, minutes: 59, seconds: 59))
        .millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: wallets
              .collection('users')
              .doc(uid)
              .collection('wallet')
              .doc(firebaseInstance.walletID.toString())
              .collection('transaction')
              .orderBy('createdOn', descending: true)
              // .startAt([_start]).endAt([_end]).snapshots(),
              .startAt([_end]).endAt([_start]).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }
            return snapshot.data.docs.length == 0
                ? noTransaction()
                : Container(
                    width: 311.w,
                    height: 300.h,
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot trans = snapshot.data.docs[index];
                          name = trans['name'];
                          if (name.length > 13) {
                            firstHalf = name.substring(0, 11);
                            secondHalf = name.substring(11, name.length);
                          } else {
                            firstHalf = name;
                            secondHalf = "";
                          }

                          if (trans['cost'] > 0) {
                            isIncome = true;
                            if (trans['cost'] > 10000) {
                              income = '+' +
                                  NumberFormat.compact()
                                      .format(trans['cost'])
                                      .toString();
                            } else {
                              income = '+' +
                                  trans['cost']
                                      .toStringAsFixed(2)
                                      .replaceAllMapped(reg, mathFunc);
                            }
                          } else {
                            isIncome = false;
                            if (trans['cost'] < -10000) {
                              expense = NumberFormat.compact()
                                  .format(trans['cost'])
                                  .toString();
                            } else {
                              expense = trans['cost']
                                  .toStringAsFixed(2)
                                  .replaceAllMapped(reg, mathFunc);
                            }
                          }

                          var time = DateFormat.yMMMd()
                              .add_jm()
                              .format(DateTime.parse(
                                  trans['createdOn'].toDate().toString()))
                              .split(" ");
                          return Container(
                              margin: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 5.h),
                              height: 66.h,
                              width: 281.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 11.w, right: 10.h),
                                          child: Container(
                                            height: 0.08.sh,
                                            width: 0.08.sw,
                                            child: SvgPicture.asset(
                                              select(trans['class']),
                                              color: Color(0xffC88EC5),
                                              height: 0.07.sh,
                                              width: 0.07.sw,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: secondHalf.isEmpty
                                                  ? new Text(
                                                      firstHalf,
                                                      style: TextStyle(
                                                          fontFamily: 'Knit',
                                                          color:
                                                              Color(0xff6A2388),
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )
                                                  : Text(
                                                      firstHalf + "...",
                                                      style: TextStyle(
                                                          fontFamily: 'Knit',
                                                          color:
                                                              Color(0xff6A2388),
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              time[3] + " " + time[4],
                                              style: TextStyle(
                                                  color: Color(0xffBCBCBC),
                                                  fontSize: 11.sp),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.h),
                                    child: isIncome
                                        ? new Text(
                                            "฿ " + income,
                                            style: TextStyle(
                                                color: Color(0xff6A2388),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : Text(
                                            "฿ " + expense,
                                            style: TextStyle(
                                                color: Color(0xff6A2388),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.right,
                                          ),
                                  ),
                                ],
                              ));
                        }),
                  );
          }),
    );
  }
}
