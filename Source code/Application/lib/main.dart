import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/src/flutter_local_notifications_plugin.dart';
import 'package:goodwallet_app/ConfirmedPage.dart';
import 'package:goodwallet_app/SpeechConfirmation.dart';
import 'Homepage.dart';
import 'Voice_Input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/Notification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

getFlexSize(screenWidth, screenHeight, pixelSize) {
  double designWidth = 360;
  double designHeight = 760;
  double designSize = 360.0 * 760;
  double screenSize = screenWidth * screenHeight;
  return pixelSize / designSize * screenSize;
}

getFlexHeight(screenHeight, pixelHeight) {
  return pixelHeight / 760 * screenHeight;
}

getFlexWidth(screenWidth, pixelWidth) {
  return pixelWidth / 360 * screenWidth;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 760),
      allowFontScaling: false,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            body1: TextStyle(
              fontFamily: "HinSiliguri",
              fontSize: 20.0.sp,
              color: Colors.white,
            ),
            button: TextStyle(
              fontFamily: "HinSiliguri",
              fontSize: 20.0.sp,
            ),
          ),
        ),
        home: Scaffold(
          body: Container(
            //Background Gradient Color
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
              ),
            ),
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}
