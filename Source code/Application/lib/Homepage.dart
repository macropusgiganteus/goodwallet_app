import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Login_popup.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 250),
            child: Hero(
                tag: 'pop_up',
                child: SvgPicture.asset('images/Logo.svg')),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(
                  builder: (context){
                    return LoginPopup();
                  }
                )
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    "SWIPE UP\nTO START",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
