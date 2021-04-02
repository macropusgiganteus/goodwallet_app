import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';

Future<Map> sumExpClass(firebaseInstance, budget) async {
  final fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;

  Map<String, double> exp = {};
  var recurrence = budget['Recurrence'];
  var _start;
  var _end;
  DateTime now = DateTime.now();
  switch (recurrence) {
    case 'Daily':
      {
        DateTime utc = DateTime.utc(now.year, now.month, now.day);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utc
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
      }
      break;
    case 'Weekly':
      {
        DateTime utc = DateTime.utc(now.year, now.month, now.day);
        var monday = new DateTime.now();
        var sunday = new DateTime.now();
        while (monday.weekday != 1) {
          monday = monday.subtract(new Duration(days: 1));
        }
        while (sunday.weekday != 7) {
          sunday = sunday.add(new Duration(days: 1));
        }

        _start = Timestamp.fromMillisecondsSinceEpoch(
            monday.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(sunday
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
      }
      break;
    case 'Monthly':
      {
        var endDay = DateUtils.getDaysInMonth(now.year, now.month);
        DateTime utcStart = DateTime.utc(now.year, now.month, 1);
        DateTime utcEnd = DateTime.utc(now.year, now.month, endDay);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utcStart.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utcEnd
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
      }
      break;
    case 'Yearly':
      {
        DateTime utcStart = DateTime.utc(now.year, 1, 1);
        DateTime utcEnd = DateTime.utc(now.year, 12, 31);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utcStart.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utcEnd
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
      }
      break;
    default:
      {
        DateTime utc = DateTime.utc(now.year, now.month, now.day);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utc
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
      }
      break;
  }

  for (var expClass in budget['BudgetClass']) {
    double sum = 0;
    try {
      Query snapshot = await fireStore
          .collection('users')
          .doc(uid)
          .collection('wallet')
          .doc(firebaseInstance.walletID.toString())
          .collection('transaction')
          .where('class', isEqualTo: expClass);
      QuerySnapshot byTime = await snapshot
          .orderBy('createdOn', descending: true)
          .startAt([_end]).endAt([_start]).get();
      for (var i = 0; i < byTime.docs.length; i++) {
        DocumentSnapshot data = byTime.docs[i];
        sum += data['cost'];
      }
    } catch (e) {
      return null;
    }
    exp[expClass] = sum;
  }

  return exp;
}
