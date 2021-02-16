import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/Budget.dart';
import 'package:goodwallet_app/Graph.dart';
import 'package:goodwallet_app/HistoryPage.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:goodwallet_app/components/TransactionList.dart';
import 'package:goodwallet_app/components/WalletCard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './Voice_Input.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

// show wallet list
class CreateWallet extends StatefulWidget {
  final firebaseInstance;
  CreateWallet(this.firebaseInstance);
  @override
  _CreateWalletState createState() => _CreateWalletState(firebaseInstance);
}

class _CreateWalletState extends State<CreateWallet> {
  final firebaseInstance;
  _CreateWalletState(this.firebaseInstance);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: firebaseInstance.wallets.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError &&
                snapshot.data.docs[firebaseInstance.walletIndex] == null) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            DocumentSnapshot wallet =
                snapshot.data.docs[firebaseInstance.walletIndex];
            return ThisWallet(
                wallet['name'], wallet['money'], wallet.id, firebaseInstance);
          }),
    );
  }
}

class ThisWallet extends StatefulWidget {
  final firebaseInstance;
  final String name;
  final money;
  final index;

  ThisWallet(this.name, this.money, this.index, this.firebaseInstance);

  @override
  _ThisWalletState createState() => _ThisWalletState(
      this.name, this.money, this.index, this.firebaseInstance);
}

class _ThisWalletState extends State<ThisWallet> with TickerProviderStateMixin {
  final firebaseInstance;
  final String name;
  final money;
  final index;
  _ThisWalletState(this.name, this.money, this.index, this.firebaseInstance);
  AnimationController _walletController;
  AnimationController _graphController;
  AnimationController _budgetController;
  var bottomClick = "Graph";
  bool bud = false;
  @override
  void initState() {
    setState(() {
      _walletController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _graphController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _budgetController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      switch (bottomClick) {
        case 'Wallet':
          _graphController.forward();
          _budgetController.forward();

          break;
        case 'Graph':
          _walletController.forward();
          _budgetController.forward();
          break;
        case 'Budget':
          _walletController.forward();
          _graphController.forward();
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Header(),
              WalletCard(widget.name, widget.money),
              Stack(
                children: [
                  SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset.zero, end: Offset(-1.5, 0))
                            .animate(CurvedAnimation(
                      parent: _walletController,
                      curve: Curves.easeIn,
                    )),
                    child: IgnorePointer(
                      ignoring: bottomClick == 'Wallet' ? false : true,
                      child: AnimatedOpacity(
                        opacity: bottomClick == 'Wallet' ? 1 : 0,
                        duration: Duration(milliseconds: 400),
                        child: Center(
                          child: Container(
                            width: _screenWidth * 0.85,
                            height: _screenHeight * 0.53,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Color.fromRGBO(255, 255, 255, 0.66)),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 19,
                                  left: 23,
                                  child: Text(
                                    "Today List",
                                    style: TextStyle(
                                      color: Color(0xff8C35B1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TransList(firebaseInstance.walletID,
                                      firebaseInstance),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return new History(
                                              firebaseInstance.walletID,
                                              firebaseInstance);
                                        }));
                                      },
                                      child: Text(
                                        "see more",
                                        style: TextStyle(
                                            color: Color(0xff8C35B1),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 11),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset.zero,
                            end: Offset(bud ? -1.5 : 1.5, 0))
                        .animate(CurvedAnimation(
                      parent: _graphController,
                      curve: Curves.easeIn,
                    )),
                    child: IgnorePointer(
                      ignoring: bottomClick == 'Graph' ? false : true,
                      child: AnimatedOpacity(
                        opacity: bottomClick == 'Graph' ? 1 : 0,
                        duration: Duration(milliseconds: 400),
                        child: Graph(firebaseInstance),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset.zero, end: Offset(1.5, 0))
                            .animate(CurvedAnimation(
                      parent: _budgetController,
                      curve: Curves.easeIn,
                    )),
                    child: IgnorePointer(
                      ignoring: bottomClick == 'Budget' ? false : true,
                      child: AnimatedOpacity(
                        opacity: bottomClick == 'Budget' ? 1 : 0,
                        duration: Duration(milliseconds: 400),
                        child: Budget(),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.078,
                        decoration: BoxDecoration(
                            color: Color(0xffE5A9B6),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23))),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 21,
                      height: MediaQuery.of(context).size.height * 0.079,
                      width: MediaQuery.of(context).size.height * 0.079,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              type: PageTransitionType.fadeIn,
                              child: VoiceInput(index, firebaseInstance)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 6,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'images/VoiceIcon.svg',
                            color: Color(0xffDB8EA7),
                            alignment: Alignment.center,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom:
                          (MediaQuery.of(context).size.height * 0.079) * 0.2,
                      // left: (MediaQuery.of(context).size.width * 0.079) * 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  bud = false;
                                  _walletController.reverse();
                                  _graphController.forward();
                                  _budgetController.forward();
                                  bottomClick = 'Wallet';
                                });
                              },
                              child: IconList(
                                  "Wallet",
                                  Icons.account_balance_wallet_outlined,
                                  Icons.account_balance_wallet),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _graphController.reverse();
                                  _walletController.forward();
                                  _budgetController.forward();

                                  bottomClick = 'Graph';
                                });
                              },
                              child: IconList(
                                  "Graph",
                                  Icons.leaderboard_outlined,
                                  Icons.leaderboard),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  bud = true;
                                  _budgetController.reverse();
                                  _walletController.forward();
                                  _graphController.forward();
                                  bottomClick = 'Budget';
                                });
                              },
                              child: IconList(
                                  "Budget",
                                  Icons.monetization_on_outlined,
                                  Icons.monetization_on_rounded),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconList extends StatefulWidget {
  final activeIcon;
  final inactiveIcon;
  final title;
  IconList(this.title, this.inactiveIcon, this.activeIcon);
  @override
  _IconListState createState() =>
      _IconListState(title, inactiveIcon, activeIcon);
}

class _IconListState extends State<IconList> {
  final activeIcon;
  final inactiveIcon;
  final title;
  _IconListState(this.title, this.inactiveIcon, this.activeIcon);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.2),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Icon(
            activeIcon,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }
}
