import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

class Graph extends StatefulWidget {
  final firebaseInstance;
  Graph(this.firebaseInstance);
  @override
  _GraphState createState() => _GraphState(firebaseInstance);
}

class _GraphState extends State<Graph> {
  int _selectedItemPosition = 0;
  final firebaseInstance;
  _GraphState(this.firebaseInstance);
  var _start;
  var _end;
  @override
  void initState() {
    // TODO: implement initState
    DateTime now = DateTime.now();
    DateTime utc = DateTime.utc(now.year, now.month, now.day);
    _start = Timestamp.fromMillisecondsSinceEpoch(
        utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
    _end = Timestamp.fromMillisecondsSinceEpoch(utc
        .add(Duration(hours: 16, minutes: 59, seconds: 59))
        .millisecondsSinceEpoch);

    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    // TODO: implement setState
    DateTime now = DateTime.now();
    DateTime utc = DateTime.utc(now.year, now.month, now.day);
    switch (_selectedItemPosition) {
      case 1:
        var endDay = DateUtils.getDaysInMonth(now.year, now.month);
        DateTime utcStart = DateTime.utc(now.year, now.month, 1);
        DateTime utcEnd = DateTime.utc(now.year, now.month, endDay);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utcStart.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utcEnd
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
        ;
        break;
      case 2:
        DateTime utcStart = DateTime.utc(now.year, 1, 1);
        DateTime utcEnd = DateTime.utc(now.year, 12, 31);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utcStart.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utcEnd
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
        break;
      default:
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utc
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      Center(
        child: Container(
          width: 0.85.sw,
          height: 0.53.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            color: Colors.white,
          ),
          child: OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: _screenHeight,
            minHeight: 0,
            maxWidth: _screenWidth,
            minWidth: 0,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80.h),
                  child: GraphComponent(firebaseInstance, this),
                ),
                SnakeNavigationBar.color(
                  height: 30.h,
                  behaviour: SnakeBarBehaviour.floating,
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  snakeViewColor: Color(0xff8C35B1),
                  snakeShape: SnakeShape.rectangle,
                  currentIndex: _selectedItemPosition,
                  onTap: (index) => setState(() {
                    _selectedItemPosition = index;
                  }),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  items: [
                    BottomNavigationBarItem(
                        icon: Text(
                      "Day",
                      style: TextStyle(
                        color: _selectedItemPosition == 0
                            ? Colors.white
                            : Color(0xff8C35B1),
                        fontSize: 16.sp,
                      ),
                    )),
                    BottomNavigationBarItem(
                      icon: Text("Month",
                          style: TextStyle(
                            color: _selectedItemPosition == 1
                                ? Colors.white
                                : Color(0xff8C35B1),
                            fontSize: 16.sp,
                          )),
                    ),
                    BottomNavigationBarItem(
                        icon: Text("Year",
                            style: TextStyle(
                              color: _selectedItemPosition == 2
                                  ? Colors.white
                                  : Color(0xff8C35B1),
                              fontSize: 16.sp,
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class GraphComponent extends StatefulWidget {
  final firebaseInstance;
  _GraphState parent;
  GraphComponent(this.firebaseInstance, this.parent);
  @override
  _GraphComponentState createState() =>
      _GraphComponentState(firebaseInstance, parent);
}

class _GraphComponentState extends State<GraphComponent>
    with TickerProviderStateMixin {
  final firebaseInstance;
  _GraphState parent;
  _GraphComponentState(this.firebaseInstance, this.parent);
  int touchedIndex;
  double incomeNumber = 0;
  double expenseNumber = 0;
  List<double> expenseClassNumber = List<double>.generate(7, (i) => 0);
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final user = FirebaseFirestore.instance.collection('users').doc(uid);
    return StreamBuilder<QuerySnapshot>(
        stream: user
            .collection('wallet')
            .doc(firebaseInstance.walletID.toString())
            .collection('transaction')
            .orderBy('createdOn', descending: true)
            .startAt([parent._end]).endAt([parent._start]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Text('');
          }
          int len = snapshot.data.docs.length;
          incomeNumber = 0;
          expenseNumber = 0;
          expenseClassNumber = List<double>.generate(7, (i) => 0);
          for (var i = 0; i < len; i++) {
            DocumentSnapshot trans = snapshot.data.docs[i];
            if (trans['cost'] > 0) {
              incomeNumber += trans['cost'];
            } else {
              expenseNumber += trans['cost'];
              switch (trans['class']) {
                case 'entertainment':
                  expenseClassNumber[2] += trans['cost'];
                  break;
                case 'residence':
                  expenseClassNumber[3] += trans['cost'];
                  break;
                case 'household':
                  expenseClassNumber[4] += trans['cost'];
                  break;
                case 'travel':
                  expenseClassNumber[5] += trans['cost'];
                  break;
                case 'health':
                  expenseClassNumber[6] += trans['cost'];
                  break;
                case 'food':
                  expenseClassNumber[0] += trans['cost'];
                  break;
                case 'shopping':
                  expenseClassNumber[1] += trans['cost'];
                  break;
              }
            }
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.h),
                    height: 48.h,
                    width: 110.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          spreadRadius: 1.0.r,
                          blurRadius: 3.5.r,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                              color: Color(0xff3FD371), fontSize: 11.sp),
                        ),
                        Text(
                          incomeNumber
                              .toStringAsFixed(2)
                              .replaceAllMapped(reg, mathFunc),
                          style: TextStyle(
                              color: Color(0xff3FD371), fontSize: 11.sp),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    height: 48.h,
                    width: 110.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          spreadRadius: 1.0.r,
                          blurRadius: 3.5.r,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Expense",
                          style: TextStyle(
                              color: Color(0xffCB3F3F), fontSize: 11.sp),
                        ),
                        Text(
                          expenseNumber
                              .toStringAsFixed(2)
                              .replaceAllMapped(reg, mathFunc),
                          style: TextStyle(
                              color: Color(0xffCB3F3F), fontSize: 11.sp),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                (incomeNumber + expenseNumber) > 0
                    ? "Change : +" +
                        (incomeNumber + expenseNumber)
                            .toStringAsFixed(2)
                            .replaceAllMapped(reg, mathFunc)
                    : "Change : " +
                        (incomeNumber + expenseNumber)
                            .toStringAsFixed(2)
                            .replaceAllMapped(reg, mathFunc),
                style: TextStyle(color: Color(0xffA1A1A1), fontSize: 11.sp),
              ),
              incomeNumber == 0 && expenseNumber == 0
                  ? noTransaction()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0.w),
                          height: 0.23.sh,
                          width: 0.45.sw,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse.touchInput
                                          is FlLongPressEnd ||
                                      pieTouchResponse.touchInput is FlPanEnd) {
                                    touchedIndex = -1;
                                  } else {
                                    touchedIndex =
                                        pieTouchResponse.touchedSectionIndex;
                                  }
                                });
                              }),
                              sections: showingSections(),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 0,
                              centerSpaceRadius: 20.r,
                            ),
                            swapAnimationDuration: Duration(milliseconds: 300),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              curve: Curves.easeInOut,
                              height: touchedIndex == 7 ? 50.h : 20.h,
                              duration: Duration(seconds: 2),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 7;
                                  });
                                },
                                child: Indicator(
                                    'Income',
                                    Color(0xffFFC9BE),
                                    Color(0xff706D6D),
                                    touchedIndex == 7 ? true : false,
                                    incomeNumber,
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              curve: Curves.fastOutSlowIn,
                              height: touchedIndex == 2 ? 50.h : 20.h,
                              duration: Duration(seconds: 2),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 2;
                                  });
                                },
                                child: Indicator(
                                    'Entertainment',
                                    Color(0xff672C76),
                                    Color(0xff706D6D),
                                    touchedIndex == 2 ? true : false,
                                    expenseClassNumber[2],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              height: touchedIndex == 3 ? 50.h : 20.h,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 3),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 3;
                                  });
                                },
                                child: Indicator(
                                    'Residence',
                                    Color(0xff8E6299),
                                    Color(0xff706D6D),
                                    touchedIndex == 3 ? true : false,
                                    expenseClassNumber[3],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              height: touchedIndex == 4 ? 50.h : 20.h,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 3),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 4;
                                  });
                                },
                                child: Indicator(
                                    'Household',
                                    Color(0xffBBA4C1),
                                    Color(0xff706D6D),
                                    touchedIndex == 4 ? true : false,
                                    expenseClassNumber[4],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              height: touchedIndex == 5 ? 50.h : 20.h,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 3),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 5;
                                  });
                                },
                                child: Indicator(
                                    'Travel',
                                    Color(0xffE4C1D0),
                                    Color(0xff706D6D),
                                    touchedIndex == 5 ? true : false,
                                    expenseClassNumber[5],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              height: touchedIndex == 6 ? 50.h : 20.h,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 3),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 6;
                                  });
                                },
                                child: Indicator(
                                    'Health',
                                    Color(0xffDAA2B9),
                                    Color(0xff706D6D),
                                    touchedIndex == 6 ? true : false,
                                    expenseClassNumber[6],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              height: touchedIndex == 0 ? 50.h : 20.h,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 3),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 0;
                                  });
                                },
                                child: Indicator(
                                    'Food',
                                    Color(0xffc57c9b),
                                    Color(0xff706D6D),
                                    touchedIndex == 0 ? true : false,
                                    expenseClassNumber[0],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                            AnimatedContainer(
                              height: touchedIndex == 1 ? 50.h : 20.h,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 3),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    touchedIndex = 1;
                                  });
                                },
                                child: Indicator(
                                    'Shopping',
                                    Color(0xff98365f),
                                    Color(0xff706D6D),
                                    touchedIndex == 1 ? true : false,
                                    expenseClassNumber[1],
                                    incomeNumber - expenseNumber),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          );
        });
  }

  List<PieChartSectionData> showingSections() {
    double total = incomeNumber - expenseNumber;
    if (total < 0) {
      total = total * (-1);
    }
    return List.generate(8, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 65.r : 55.r;
      switch (i) {
        case 0:
          return pieChartSectionData(
              value: expenseClassNumber[0] * (100 / total) * (-1),
              color: Color(0xffc57c9b),
              radius: radius,
              title: '');
        case 1:
          return pieChartSectionData(
              value: expenseClassNumber[1] * (100 / total) * (-1),
              color: Color(0xff98365f),
              radius: radius,
              title: '');
        case 2:
          return pieChartSectionData(
              value: expenseClassNumber[2] * (100 / total) * (-1),
              color: Color(0xff672C76),
              radius: radius,
              title: '');
        case 3:
          return pieChartSectionData(
              value: expenseClassNumber[3] * (100 / total) * (-1),
              color: Color(0xff8E6299),
              radius: radius,
              title: '');
        case 4:
          return pieChartSectionData(
              value: expenseClassNumber[4] * (100 / total) * (-1),
              color: Color(0xffBBA4C1),
              radius: radius,
              title: '');
        case 5:
          return pieChartSectionData(
              value: expenseClassNumber[5] * (100 / total) * (-1),
              color: Color(0xffE4C1D0),
              radius: radius,
              title: '');
        case 6:
          return pieChartSectionData(
              value: expenseClassNumber[6] * (100 / total) * (-1),
              color: Color(0xffDAA2B9),
              radius: radius,
              title: '');
        case 7:
          return pieChartSectionData(
              value: incomeNumber * (100 / total),
              color: Color(0xffFFC9BE),
              radius: radius,
              title: '');
        default:
          return null;
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color _color;
  final String _title;
  final Color _textColor;
  final bool _open;
  final double number;
  final double total;
  Indicator(this._title, this._color, this._textColor, this._open, this.number,
      this.total);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: _color),
                height: 10.h,
                width: 10.w,
              ),
              SizedBox(width: 5.w),
              Text(
                _title,
                style: TextStyle(color: _textColor, fontSize: 9.sp),
              )
            ],
          ),
          Visibility(
            visible: _open,
            child: Row(
              children: [
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number < 0
                          ? (number * (-100 / total)).toStringAsFixed(2) + '%'
                          : (number * (100 / total)).toStringAsFixed(2) + '%',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xff706D6D),
                          height: 1.2),
                    ),
                    Text(
                      number
                              .toStringAsFixed(2)
                              .replaceAllMapped(reg, mathFunc) +
                          ' THB',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xffF75454),
                          height: 1.2),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

pieChartSectionData({Color color, double value, double radius, String title}) {
  return PieChartSectionData(
      color: color,
      value: (value.isNaN || value == 0) ? 0.01 : value,
      radius: radius,
      title: title,
      titleStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      titlePositionPercentageOffset: 0.7);
}

Widget noTransaction() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 30.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long, color: Color(0xff706D6D), size: 50.w),
        Text("No transactions yet",
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff706D6D))),
        Text(
          "After you add first transaction today \nyou will be able to view it here.",
          style: TextStyle(fontSize: 9.sp, color: Color(0xffA1A1A1)),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
