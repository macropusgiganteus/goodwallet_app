import 'package:carousel_slider/carousel_slider.dart';
import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/Voice_Input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletSlider extends StatefulWidget {
  final firebaseInstance;
  WalletSlider(this.firebaseInstance);
  @override
  _WalletSliderState createState() => _WalletSliderState(firebaseInstance);
}

int _currentWalletIndex = 0;

class _WalletSliderState extends State<WalletSlider> {
  final firebaseInstance;
  _WalletSliderState(this.firebaseInstance);

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  CarouselController walletButtonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseInstance.wallets.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List cardList = [];
        // ignore: deprecated_member_use
        if (snapshot.data != null) {
          for (var n in snapshot.data.docs) {
            cardList.add(WalletItem(n['name']));
          }
        }
        return Container(
          height: 0.05.sh, //0.05
          width: 0.6.sw, //0.45
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r), color: Colors.white),
          margin: EdgeInsets.only(bottom: 20.h),
          child: Row(children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  walletButtonCarouselController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                });
              },
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Color(0xffB58FE7),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 0.05.sh,
                child: CarouselSlider(
                  carouselController: walletButtonCarouselController,
                  options: CarouselOptions(
                    height: 50.0.h,
                    autoPlay: false,
                    initialPage: firebaseInstance.walletIndex,
                    // autoPlayInterval: Duration(seconds: 3),
                    // autoPlayAnimationDuration: Duration(milliseconds: 800),
                    // autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentWalletIndex = index;
                        firebaseInstance.walletIndex = index;
                        firebaseInstance.walletID =
                            snapshot.data.docs[index].id;
                      });
                    },
                  ),
                  items: cardList.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        // height: MediaQuery.of(context).size.height * 0.01,
                        width: double.infinity,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          // color: Color(0xff9967B2),
                          child: Center(
                            child: card,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  walletButtonCarouselController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                });
              },
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Color(0xffB58FE7),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class WalletItem extends StatelessWidget {
  final walletName;
  WalletItem(this.walletName);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        walletName,
        style: TextStyle(
            color: Color(0xffB58FE7),
            fontSize: walletName.length > 9 ? 13.sp : 16.sp),
      ),
    );
  }
}
