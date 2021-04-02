import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPopup extends StatefulWidget {
  @override
  _LoginPopupState createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Align(
          alignment: FractionalOffset(0.5,0.3),
          child: Hero(
            tag: 'pop_up',
            child: SvgPicture.asset('images/Logo.svg'),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(71),
                topRight: Radius.circular(71),
              ),
              color: Color(0xFFF4F6FF),
            ),
            height: 300,
            padding: EdgeInsets.fromLTRB(60, 0, 60, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.horizontal_rule_rounded),
                    color: Color(0xffC78EC8),
                    iconSize: 60,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text('Welcome',
                  style: TextStyle(
                      color:Color(0xff8C35B1),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: 'HinSiliguri',
                      decoration: TextDecoration.none,
                  ),),
                SizedBox(height: 20,),
                Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris euismod erat.',style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff8C35B1),
                  fontFamily: 'HinSiliguri',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                ),),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'login_button',
                      child:
                        FlatButton(
                          height: 47,
                          minWidth: 127,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          padding: EdgeInsets.all(6),
                          onPressed: (){},
                          color: Color(0xff8C35B1),
                          child: Text("Sign In",style: TextStyle(fontSize: 14),),
                          textColor: Colors.white,
                        ),
                    ),
                    SizedBox(width: 11),
                    Hero(
                      tag: 'signup_buttton',
                      child: FlatButton(
                        height: 47,
                        minWidth: 127,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                        padding: EdgeInsets.all(6),
                        onPressed: (){},
                        color: Color(0xffB58FE7),
                        child: Text("Sign Up",style: TextStyle(fontSize: 14),),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
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


