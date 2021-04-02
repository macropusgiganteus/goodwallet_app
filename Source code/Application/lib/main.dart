import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Homepage.dart';

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_){
    runApp(MyApp());
  }
  );
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(
            fontFamily: "HinSiliguri",
            fontSize: 20.0,
            color: Colors.white,
          ),
          button: TextStyle(
            fontFamily: "HinSiliguri",
            fontSize: 20.0,
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

    );
  }
}
