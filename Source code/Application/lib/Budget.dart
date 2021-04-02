import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/components/BudgetComponent.dart';
import 'package:goodwallet_app/components/Manual_expense_component.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodwallet_app/classes/SearchClassForBudget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Budget extends StatefulWidget {
  final firebaseInstance;
  Budget(this.firebaseInstance);
  @override
  _BudgetState createState() => _BudgetState(firebaseInstance);
}

class _BudgetState extends State<Budget> {
  final firebaseInstance;
  _BudgetState(this.firebaseInstance);
  var _height;
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  var _screenHeight;
  var _screenWidth;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    _height = _screenHeight;
    return Center(
      child: Container(
        width: 0.85.sw,
        height: 0.55.sh,
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'images/money_bag.svg',
                  color: Colors.white,
                  width: 20.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Budget",
                  style: TextStyle(fontSize: 20.sp),
                ),
              ],
            ),
            new Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('users')
                    .doc(uid)
                    .collection('wallet')
                    .doc(firebaseInstance.walletID.toString())
                    .collection('budget')
                    .orderBy('CreatedOn', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading..."));
                  }
                  var len = snapshot.data.docs.length;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: len,
                            itemBuilder: (context, index) {
                              DocumentSnapshot budget =
                                  snapshot.data.docs[index];
                              return Slidable(
                                actionPane: SlidableScrollActionPane(),
                                actionExtentRatio: 0.25,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: 66.h),
                                  child:
                                      BudgetComponent(budget, firebaseInstance),
                                ),
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'Delete',
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                    color: Color(0x000000),
                                    onTap: () {
                                      budget.reference.delete();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              );
                            }),
                        GestureDetector(
                          onTap: budgetDialog,
                          child: Container(
                            height: 0.1.sh,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            margin: EdgeInsets.symmetric(vertical: 6.h),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13.r)),
                                color: Colors.white),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.add_box_outlined,
                                    color: Color(0xffEA8D8D),
                                    size: 20.w,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Add New Budget",
                                    style: TextStyle(
                                      color: Color(0xffEA8D8D),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final snackBar = SnackBar(
    content: Text(
      'Budget has been deleted.',
      style: TextStyle(fontSize: 12.sp),
    ),
  );

  budgetDialog() {
    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: _height * 0.75,
              margin: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 50.h),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0.r)),
                  color: Colors.white),
              child: Column(children: [
                Stack(children: [
                  Center(
                    child: Text("Add New Budget",
                        style: TextStyle(
                            color: Color(0xffEA8D8D),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'HinSiliguri',
                            decoration: TextDecoration.none)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      child: Icon(
                        Icons.clear_rounded,
                        color: Color(0xffEA8D8D),
                        size: 30.w,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
                SizedBox(height: 20.h),
                AddNewBudget(firebaseInstance)
              ]),
            ),
          );
        });
  }
}

class AddNewBudget extends StatefulWidget {
  final firebaseInstance;
  AddNewBudget(this.firebaseInstance);
  @override
  _AddNewBudgetState createState() => _AddNewBudgetState(firebaseInstance);
}

class _AddNewBudgetState extends State<AddNewBudget> {
  final firebaseInstance;
  _AddNewBudgetState(this.firebaseInstance);
  final uid = FirebaseAuth.instance.currentUser.uid;
  final _fireStore = FirebaseFirestore.instance;
  var recurrence = 'Daily';
  String budgetName = '';
  double amount = 0.0;
  Map<String, bool> classSelected = {
    'entertainment': false,
    'residence': false,
    'household': false,
    'travel': false,
    'health': false,
    'food': false,
    'shopping': false
  };
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x00000000),
      child: Column(
        children: [
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  borderSide:
                      BorderSide(color: Color(0xffEA8D8D), width: 1.5.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  borderSide:
                      BorderSide(color: Color(0xffEA8D8D), width: 1.5.w),
                ),
                hintText: "Budget Name...",
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: Color(0xffEA8D8D))),
            style: TextStyle(fontSize: 12.sp, color: Color(0xffEA8D8D)),
            onChanged: (String str) {
              setState(() {
                budgetName = str;
                print(str);
              });
            },
          ),
          SizedBox(height: 15.h),
          TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  borderSide:
                      BorderSide(color: Color(0xffEA8D8D), width: 1.5.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  borderSide:
                      BorderSide(color: Color(0xffEA8D8D), width: 1.5.w),
                ),
                hintText: "Amount...",
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: Color(0xffEA8D8D))),
            style: TextStyle(fontSize: 12.sp, color: Color(0xffEA8D8D)),
            onChanged: (String str) {
              setState(() {
                amount = double.parse(str);
                print(str);
              });
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 17.h, horizontal: 10.w),
              child: Text(
                "Select Type Of Budget",
                style: TextStyle(
                    color: Color(0xffEA8D8D),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['entertainment'] =
                            !classSelected['entertainment'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['entertainment'] ? 1 : 0.5,
                      child: expenseClass('Entertainment', 'Entertainment',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['residence'] =
                            !classSelected['residence'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['residence'] ? 1 : 0.5,
                      child: expenseClass('Residence', 'Residence',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['household'] =
                            !classSelected['household'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['household'] ? 1 : 0.5,
                      child: expenseClass('Household', 'Household',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['travel'] = !classSelected['travel'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['travel'] ? 1 : 0.5,
                      child:
                          expenseClass('Travel', 'Travel', color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['health'] = !classSelected['health'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['health'] ? 1 : 0.5,
                      child:
                          expenseClass('Health', 'Health', color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['food'] = !classSelected['food'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['food'] ? 1 : 0.5,
                      child: expenseClass('Food', 'Food', color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['shopping'] = !classSelected['shopping'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['shopping'] ? 1 : 0.5,
                      child: expenseClass('Shopping', 'Shopping',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 17.h, horizontal: 10.w),
              child: Text(
                "Recurrence",
                style: TextStyle(
                    color: Color(0xffEA8D8D),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          MenuButton(
            menuButtonBackgroundColor: Color(0),
            child: SizedBox(
              height: 40.h,
              width: double.infinity,
              child: Center(
                child: Text(recurrence,
                    style:
                        TextStyle(color: Color(0xffEA8D8D), fontSize: 16.sp)),
              ),
            ),
            selectedItem: recurrence,
            onItemSelected: (value) {
              setState(() {
                recurrence = value;
              });
            },
            items: ["Daily", "Weekly", "Monthly", "Yearly"],
            itemBuilder: (value) => Container(
                width: double.infinity,
                height: 35.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  value,
                  style: TextStyle(color: Color(0xffEA8D8D), fontSize: 16.sp),
                )),
            toggledChild: SizedBox(
              height: 40.h,
              width: double.infinity,
              child: Center(
                child: Text(recurrence,
                    style:
                        TextStyle(color: Color(0xffEA8D8D), fontSize: 16.sp)),
              ),
            ),
            topDivider: false,
            divider: Opacity(
              opacity: 0.2,
              child: Container(
                height: 0.5.h,
                color: Color(0xffEA8D8D),
              ),
            ),
            onMenuButtonToggle: (value) => null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24.r)),
              border: Border.all(color: Color(0xffEA8D8D), width: 1.5.w),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50.h),
          GestureDetector(
            onTap: () {
              print(budgetName + ' ' + amount.toString() + recurrence);
              print(classSelected.keys
                  .where((element) => classSelected[element] == true));
              var budgetClass = classSelected.keys
                  .where((element) => classSelected[element] == true)
                  .toList();
              _fireStore
                  .collection('users')
                  .doc(uid)
                  .collection('wallet')
                  .doc(firebaseInstance.walletID.toString())
                  .collection('budget')
                  .add({
                'BudgetName': budgetName,
                'Amount': amount,
                'BudgetClass': budgetClass,
                'CreatedOn': FieldValue.serverTimestamp(),
                'Recurrence': recurrence,
              });
              Navigator.pop(context);
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                  color: Color(0xffEA8D8D),
                  borderRadius: BorderRadius.all(Radius.circular(50.r))),
              child: Center(
                  child: Text('Create New Budget',
                      style: TextStyle(fontSize: 16.sp))),
            ),
          )
        ],
      ),
    );
  }
}
