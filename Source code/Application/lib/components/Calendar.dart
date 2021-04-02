import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/components/IconSelector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Calendar extends StatefulWidget {
  final index;
  Calendar(this.index);
  @override
  _CalendarState createState() => _CalendarState(index);
}

class _CalendarState extends State<Calendar> {
  final walletID;
  _CalendarState(this.walletID);
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    DateTime now = DateTime.now();
    DateTime utc = DateTime.utc(now.year, now.month, now.day);
    _start = Timestamp.fromMillisecondsSinceEpoch(
        utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
    _end = Timestamp.fromMillisecondsSinceEpoch(utc
        .add(Duration(hours: 16, minutes: 59, seconds: 59))
        .millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  var _dateSelect;
  var _start;
  var _end;
  bool isIncome;
  var income;
  var expense;
  String _dateString = '';
  final wallets = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  int _selectedItemPosition = 0;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              color: Colors.white,
            ),
            child: TableCalendar(
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                  selectedStyle: TextStyle(fontSize: 20.sp),
                  todayStyle: TextStyle(fontSize: 20.sp),
                  selectedColor: Color(0xffB58FE7),
                  todayColor: Color(0xff6A2388),
                  markersColor: Colors.brown[700],
                  outsideDaysVisible: true,
                  weekdayStyle: TextStyle(color: Color(0xffA1A1A1)),
                  weekendStyle: TextStyle(color: Color(0xffA1A1A1)),
                  holidayStyle: TextStyle(color: Color(0xffA1A1A1)),
                  eventDayStyle: TextStyle(color: Color(0xffA1A1A1))),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Color(0xffB58FE7)),
                weekendStyle: TextStyle(color: Color(0xffB58FE7)),
              ),
              headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: Color(0xff6A2388)),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                      color: Color(0xffB58FE7),
                      borderRadius: BorderRadius.circular(25.r))),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
              },
              onDaySelected: (date, events, holidays) {
                setState(() {
                  _dateSelect = date;
                  _dateString = _dateSelect.toString();
                  _start = Timestamp.fromMillisecondsSinceEpoch(_dateSelect
                      .add(new Duration(hours: -19))
                      .millisecondsSinceEpoch);
                  _end = Timestamp.fromMillisecondsSinceEpoch(_dateSelect
                      .add(new Duration(hours: 5))
                      .millisecondsSinceEpoch);
                });
              },
            ),
          ),
          new Expanded(
              child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: wallets
                    .collection('users')
                    .doc(uid)
                    .collection('wallet')
                    .doc(walletID)
                    .collection('transaction')
                    .orderBy('createdOn', descending: false)
                    .startAt([_start]).endAt([_end]).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot trans = snapshot.data.docs[index];
                        var time = DateFormat.yMMMd()
                            .add_jm()
                            .format(DateTime.parse(
                                trans['createdOn'].toDate().toString()))
                            .split(" ");
                        if (trans['cost'] > 0) {
                          isIncome = true;
                          income = '+' +
                              trans['cost']
                                  .toStringAsFixed(2)
                                  .replaceAllMapped(reg, mathFunc);
                        } else {
                          isIncome = false;
                          expense = trans['cost']
                              .toStringAsFixed(2)
                              .replaceAllMapped(reg, mathFunc);
                        }

                        return Slidable(
                          actionPane: SlidableScrollActionPane(),
                          actionExtentRatio: 0.25,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 66.h),
                            child: Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 5.h),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 8.0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              height: 0.08.sh,
                                              width: 0.08.sw,
                                              child: SvgPicture.asset(
                                                select(trans['class']),
                                                color: Color(0xffC88EC5),
                                                height: 0.08.sh,
                                                width: 0.08.sw,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 0.33.sw),
                                                  child: Text(
                                                    trans['name'],
                                                    style: TextStyle(
                                                        fontFamily: 'Knit',
                                                        color:
                                                            Color(0xff6A2388),
                                                        fontSize: 16.sp,
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
                                            ? Text(
                                                "฿ " + income,
                                                style: TextStyle(
                                                    color: Color(0xff6A2388),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.right,
                                              )
                                            : Text(
                                                "฿ " + expense,
                                                style: TextStyle(
                                                    color: Color(0xff6A2388),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.right,
                                              ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              icon: Icons.delete,
                              foregroundColor: Colors.white,
                              color: Color(0x000000),
                              onTap: () async {
                                CollectionReference wallet = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('wallet');
                                wallet
                                    .doc(walletID.toString())
                                    .update({
                                      'money':
                                          FieldValue.increment(-trans['cost'])
                                    })
                                    .then((value) => print("Wallet Updated"))
                                    .catchError((error) => print(
                                        "Failed to update wallet: $error"));
                                await trans.reference.delete();
                              },
                            ),
                          ],
                        );
                      });
                }),
          )),
        ],
      ),
    );
  }
}
