import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/AddWallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goodwallet_app/components/Notification.dart';
import 'package:goodwallet_app/main.dart';
import 'package:intl/intl.dart';
import 'CreateWallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'Voice_Input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  AnimationController _controller;
  double openNav = 0.0;
  final _auth = FirebaseAuth.instance;
  var name;
  var email;
  var pic;
  bool _notification = false;

  var _notifyTime1 = [0, 0];
  var _notifyTime2 = [0, 0];
  var _notifyTime3 = [0, 0];

  @override
  void dispose() {
    super.dispose();
  }

  Future userHandler() async {
    try {
      name = await _auth.currentUser.displayName;
      email = await _auth.currentUser.email;
      pic = await _auth.currentUser.photoURL;
      print(pic);
    } catch (e) {
      print(e);
    }
  }

  checkNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notificationStatus = prefs.getBool('NotificationStatus');
    print(notificationStatus);
    if (notificationStatus == null) {
      _notification = false;
    } else {
      _notification = notificationStatus;
    }
  }

  sendNotification(id, hour, minute, second) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        'Hello, spender.',
        "Don't forget to note your expenses",
        Time(hour, minute, second),
        platformChannelSpecifics,
        payload: '');
  }

  @override
  void initState() {
    print('-----');
    checkNotificationStatus();
    print('======');
    setState(() {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    });
    super.initState();
    message = "No message.";
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        // ignore: missing_return
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // ignore: missing_return
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        //Background Gradient Color
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),

        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(26.w, 35.h, 22.5.w, 60.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.reverse();
                            openNav = 1.0;
                          });
                        },
                        child: Icon(Icons.account_circle_rounded,
                            color: Colors.white, size: 35.w),
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
                ),
                TotalCard(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 30.h),
                    child: WalletList(this),
                    width: 0.83.sw,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddWallet();
                    }));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.078.sh,
                    decoration: BoxDecoration(
                        color: Color(0xffE5A9B6),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(23.r),
                            topRight: Radius.circular(23.r))),
                    child: Center(
                      child: Text(
                        "Add new wallet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: Offset(0, 0), end: Offset(-1.5, 0))
                        .animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeIn,
                )),
                child: IgnorePointer(
                  ignoring: openNav == 0 ? true : false,
                  child: AnimatedOpacity(
                    opacity: openNav,
                    duration: Duration(milliseconds: 400),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.forward();
                          openNav = 0.0;
                        });
                      },
                      onPanUpdate: (details) {
                        if (details.delta.dx < 0) {
                          setState(() {
                            _controller.forward();
                            openNav = 0.0;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            0.05.sw, 0.05.sh, 0.02.sw, 0.05.sh),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.r)),
                          color: Colors.white,
                        ),
                        height: screenHeight,
                        width: 0.6.sw,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: userHandler(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        pic != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(pic),
                                              )
                                            : SvgPicture.asset(
                                                'images/account.svg',
                                                width: 35.w,
                                                color: Color(0xffC88EC5),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: Text(
                                            name == null ? 'Guest' : name,
                                            style: TextStyle(
                                                color: Color(0xff706D6D),
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          email == null
                                              ? 'guest@mail.com'
                                              : email,
                                          style: TextStyle(
                                              color: Color(0xffA1A1A1),
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 0.1.sh),
                                Text(
                                  'Other',
                                  style: TextStyle(
                                      color: Color(0xff706D6D),
                                      fontSize: 14.sp),
                                ),
                                Divider(
                                  color: Color(0xffC88EC5),
                                  thickness: 0.2.h,
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: notificationSetting,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.notifications_active_rounded,
                                      color: Color(0xffC88EC5),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Notification',
                                          style: TextStyle(
                                              color: Color(0xffA1A1A1),
                                              fontSize: 11.sp),
                                        ),
                                        CupertinoSwitch(
                                          value: _notification ?? false,
                                          onChanged: (bool value) async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              _notification = value;
                                              prefs.setBool(
                                                  'NotificationStatus', value);
                                            });
                                            if (_notification) {
                                              sendNotification(
                                                  0,
                                                  _notifyTime1[0],
                                                  _notifyTime1[1],
                                                  0);
                                              sendNotification(
                                                  1,
                                                  _notifyTime2[0],
                                                  _notifyTime2[1],
                                                  0);
                                              sendNotification(
                                                  3,
                                                  _notifyTime3[0],
                                                  _notifyTime3[1],
                                                  0);

                                              // sendNotification();
                                              print("Turned on notification");

                                              final List<
                                                      PendingNotificationRequest>
                                                  pendingNotificationRequests =
                                                  await flutterLocalNotificationsPlugin
                                                      .pendingNotificationRequests();
                                              pendingNotificationRequests
                                                  .forEach((element) {
                                                print(element.id.toString() +
                                                    ' ' +
                                                    element.body);
                                              });
                                            } else {
                                              flutterLocalNotificationsPlugin
                                                  .cancelAll();
                                              print(
                                                  "All notifications are canceled");
                                            }
                                          },
                                          activeColor: Color(0xffEA8D8D),
                                        )
                                      ],
                                    ),
                                    horizontalTitleGap: 0.5.w,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                ),
                                Divider(
                                  color: Color(0xffC88EC5),
                                  thickness: 0.2.h,
                                  height: 10.h,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setStringList('user', null);
                                    prefs.setString('token', null);
                                    try {
                                      await _auth.signOut();
                                    } catch (e) {
                                      print(e);
                                    }
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MyApp();
                                    }));
                                  },
                                  leading: Icon(
                                    Icons.logout,
                                    color: Color(0xffC88EC5),
                                  ),
                                  title: Text(
                                    'Log out',
                                    style: TextStyle(
                                        color: Color(0xff706D6D),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  horizontalTitleGap: 0.5.w,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  notificationSetting() {
    showDialog(
        barrierColor: Colors.grey[350].withOpacity(0.4),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              color: Color(0),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  height: 264.h,
                  width: 264.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                        color: Color(0xffC88EC5),
                        width: 1.0.w,
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Stack(children: [
                        Center(
                          child: Text("NOTIFICATION SETTING",
                              style: TextStyle(
                                  color: Color(0xff6A2388),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HinSiliguri',
                                  decoration: TextDecoration.none)),
                        ),
                        Positioned(
                          right: 5.w,
                          top: 0,
                          child: GestureDetector(
                            child: Icon(
                              Icons.clear_rounded,
                              color: Color(0xffEA8D8D),
                              size: 18.w,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 26.w),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15.h),
                              child: Row(
                                children: [
                                  Text(
                                    '1.',
                                    style: TextStyle(
                                        color: Color(0xffEA8D8D),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HinSiliguri',
                                        decoration: TextDecoration.none),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.w),
                                    width: 60.w,
                                    height: 27.h,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      cursorColor: Colors.grey[600],
                                      cursorWidth: 1.0,
                                      maxLength: 2,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(3.h),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        hintText: "7",
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xffEA8D8D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffEA8D8D)),
                                      textAlign: TextAlign.center,
                                      onChanged: (str) {
                                        _notifyTime1[0] =
                                            int.tryParse(str) ?? 0;
                                      },
                                    ),
                                  ),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                        color: Color(0xffEA8D8D),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HinSiliguri',
                                        decoration: TextDecoration.none),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.w),
                                    width: 60.w,
                                    height: 27.h,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      cursorColor: Colors.grey[600],
                                      cursorWidth: 1.0,
                                      maxLength: 2,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(3.h),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        hintText: "00",
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xffEA8D8D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xffEA8D8D)),
                                      textAlign: TextAlign.center,
                                      onChanged: (str) {
                                        _notifyTime1[1] =
                                            int.tryParse(str) ?? 0;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.h),
                              child: Row(
                                children: [
                                  Text(
                                    '2.',
                                    style: TextStyle(
                                        color: Color(0xffEA8D8D),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HinSiliguri',
                                        decoration: TextDecoration.none),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.w),
                                    width: 60.w,
                                    height: 27.h,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      cursorColor: Colors.grey[600],
                                      cursorWidth: 1.0,
                                      maxLength: 2,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(3.h),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        hintText: "12",
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xffEA8D8D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffEA8D8D)),
                                      textAlign: TextAlign.center,
                                      onChanged: (str) {
                                        _notifyTime2[0] =
                                            int.tryParse(str) ?? 0;
                                      },
                                    ),
                                  ),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                        color: Color(0xffEA8D8D),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HinSiliguri',
                                        decoration: TextDecoration.none),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.w),
                                    width: 60.w,
                                    height: 27.h,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      cursorColor: Colors.grey[600],
                                      cursorWidth: 1.0,
                                      maxLength: 2,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(3.h),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        hintText: "00",
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xffEA8D8D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xffEA8D8D)),
                                      textAlign: TextAlign.center,
                                      onChanged: (str) {
                                        _notifyTime2[1] =
                                            int.tryParse(str) ?? 0;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.h),
                              child: Row(
                                children: [
                                  Text(
                                    '3.',
                                    style: TextStyle(
                                        color: Color(0xffEA8D8D),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HinSiliguri',
                                        decoration: TextDecoration.none),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.w),
                                    width: 60.w,
                                    height: 27.h,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      cursorColor: Colors.grey[600],
                                      cursorWidth: 1.0,
                                      maxLength: 2,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(3.h),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        hintText: "18",
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xffEA8D8D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffEA8D8D)),
                                      textAlign: TextAlign.center,
                                      onChanged: (str) {
                                        _notifyTime3[0] =
                                            int.tryParse(str) ?? 0;
                                      },
                                    ),
                                  ),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                        color: Color(0xffEA8D8D),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HinSiliguri',
                                        decoration: TextDecoration.none),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.w),
                                    width: 60.w,
                                    height: 27.h,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      cursorColor: Colors.grey[600],
                                      cursorWidth: 1.0,
                                      maxLength: 2,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(3.h),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r)),
                                          borderSide: BorderSide(
                                              color: Color(0xffCB80AD),
                                              width: 0.5.w),
                                        ),
                                        hintText: "00",
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xffEA8D8D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xffEA8D8D)),
                                      textAlign: TextAlign.center,
                                      onChanged: (str) {
                                        _notifyTime3[1] =
                                            int.tryParse(str) ?? 0;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.h),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                flutterLocalNotificationsPlugin.cancelAll();
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  _notification = true;
                                  prefs.setBool('NotificationStatus', true);
                                });
                                if (_notification) {
                                  sendNotification(
                                      0, _notifyTime1[0], _notifyTime1[1], 0);
                                  sendNotification(
                                      1, _notifyTime2[0], _notifyTime2[1], 0);
                                  sendNotification(
                                      2, _notifyTime3[0], _notifyTime3[1], 0);

                                  // sendNotification();
                                  print("Turned on notification");

                                  final List<PendingNotificationRequest>
                                      pendingNotificationRequests =
                                      await flutterLocalNotificationsPlugin
                                          .pendingNotificationRequests();
                                  pendingNotificationRequests
                                      .forEach((element) {
                                    print(element.id.toString() +
                                        ' ' +
                                        element.body);
                                  });
                                }
                              },
                              child: Container(
                                height: 36.h,
                                decoration: BoxDecoration(
                                    color: Color(0xffC88EC5),
                                    borderRadius: BorderRadius.circular(50.r)),
                                child: Center(
                                  child: Text('CONFIRM',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: 'HinSiliguri',
                                          decoration: TextDecoration.none)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }
}

class TotalCard extends StatelessWidget {
  @override
  // string format for money (comma)
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  final _auth = FirebaseAuth.instance;
  double money = 0;
  getTotal() {
    return fetchTotal().then((value) {
      money = value;
      return value;
    }).catchError((error) => throw (error));
  }

  Future<double> fetchTotal() async {
    double money = 0;
    final uid = _auth.currentUser.uid;
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .snapshots()) {
      for (var wallet in snapshot.docs) {
        final cost = wallet.get('money');
        money = money + cost;
      }
      return money;
    }
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 314.w,
      height: 147.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(34.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Text(
              "TOTAL",
              style: TextStyle(
                  color: Color(0xffA1A1A1),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder(
            future: getTotal(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                getTotal();
                return Text('0');
              } else {
                return Container(
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
                );
              }
            },
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
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class WalletList extends StatelessWidget {
  _WalletState parent;
  WalletList(this.parent);
  @override
  // string format for money (comma)
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final uid = _auth.currentUser.uid;
    dynamic firebaseInstance = FirebaseInstance(uid);
    firebaseInstance.fetchWallet();
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: firebaseInstance.wallets.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView.builder(
            // ignore: deprecated_member_use
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              // ignore: deprecated_member_use
              DocumentSnapshot wallet = snapshot.data.docs[index];
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: GestureDetector(
                  onTap: () {
                    firebaseInstance.walletIndex = index;
                    firebaseInstance.walletID = wallet.id;
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.fadeIn,
                        duration: Duration(milliseconds: 100),
                        child: new CreateWallet(firebaseInstance)));
                  },
                  child: Container(
                    height: 0.096.sh,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 7.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wallet['name'],
                            style: TextStyle(
                                color: Color(0xffA1A1A1),
                                fontSize: wallet['name'].toString().length > 9
                                    ? 16.sp
                                    : 20.sp,
                                decoration: TextDecoration.none,
                                fontFamily: 'Knit'),
                          ),
                          Text(
                            wallet['money']
                                .toStringAsFixed(2)
                                .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(
                                color: Color(0xffA890FE),
                                fontSize:
                                    wallet['money'] > 10000 ? 26.sp : 32.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34.r),
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    icon: Icons.delete,
                    foregroundColor: Colors.white,
                    color: Color(0x00000000),
                    onTap: () async {
                      await wallet.reference.delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text(
                            'Wallet ${wallet['name']} has been deleted.',
                            textAlign: TextAlign.center,
                          )));
                      parent.setState(() {});

                      // Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return new Wallet();
                      // }));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FirebaseInstance {
  var uid;
  var wallets;

  FirebaseInstance(this.uid);

  // WalletInstance(this.wallets);
  var walletIndex;
  var walletID;

  void fetchWallet() {
    this.wallets = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .orderBy('createdOn', descending: false);
  }
}
