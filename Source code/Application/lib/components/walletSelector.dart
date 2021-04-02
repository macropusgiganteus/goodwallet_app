import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletSelector extends StatefulWidget {
  final currentTransaction;
  WalletSelector(this.currentTransaction);
  @override
  _WalletSelectorState createState() =>
      _WalletSelectorState(currentTransaction);
}

class _WalletSelectorState extends State<WalletSelector> {
  // ignore: deprecated_member_use
  final currentTransaction;
  _WalletSelectorState(this.currentTransaction);

  final wallets = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var selectedItem = '';
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: wallets
            .collection('users')
            .doc(uid)
            .collection('wallet')
            .orderBy('createdOn', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List listWallet = [];
          List listWalletID = [];
          for (var n in snapshot.data.docs) {
            listWallet.add(n['name']);
            listWalletID.add(n.id);
          }
          return MenuButton(
            menuButtonBackgroundColor: Color(0),
            child: SizedBox(
              width: 120.w,
              height: 40.h,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 11.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        selectedItem,
                        style: TextStyle(
                            color: Color(0xffA890FE), fontSize: 13.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                        width: 12.w,
                        height: 17.h,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Color(0xffA890FE),
                            ))),
                  ],
                ),
              ),
            ), // Widget displayed as the button
            items: listWallet, // List of your items,
            topDivider: true,
            // popupHeight:
            //     180, // This popupHeight is optional. The default height is the size of items
            scrollPhysics:
                AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
            itemBuilder: (value) => Container(
                width: 83.w,
                height: 40.h,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  value,
                  style: TextStyle(color: Color(0xffA890FE), fontSize: 13.sp),
                )), // Widget displayed for each item
            toggledChild: Container(
              color: Colors.white,
              child: SizedBox(
                width: 83.w,
                height: 40.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 11.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          selectedItem,
                          style: TextStyle(
                              color: Color(0xffA890FE), fontSize: 13.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                          width: 12.w,
                          height: 17.h,
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.grey,
                              ))),
                    ],
                  ),
                ),
              ), // Widget displayed as the button,
            ),
            divider: Container(),
            onItemSelected: (value) {
              setState(() {
                selectedItem = value;
                var idIndex = listWallet.indexOf(value);
                var idValue = listWalletID[idIndex];
                currentTransaction.setTargetWallet(value, idValue);
              });
// Action when new item is selected
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24.r)),
              border: Border.all(color: Color(0xffA890FE), width: 1.5.w),
              color: Colors.white,
            ),
            onMenuButtonToggle: (isToggle) {},
          );
        });
  }
}
