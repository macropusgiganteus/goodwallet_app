// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class Notification extends StatefulWidget {
//   @override
//   _NotificationState createState() => _NotificationState();
// }
//
// class _NotificationState extends State<Notification> {
//   FlutterLocalNotificationsPlugin fltrNotification;
//   String _selectedParam;
//   String task;
//   int val;
//
//   @override
//   void initState() {
//     super.initState();
//     var androidInitilize = new AndroidInitializationSettings('ic_launcher');
//     var iOSinitilize = new IOSInitializationSettings();
//     var initilizationsSettings =
//         new InitializationSettings(androidInitilize, iOSinitilize);
//     fltrNotification = new FlutterLocalNotificationsPlugin();
//     fltrNotification.initialize(initilizationsSettings,
//         onSelectNotification: notificationSelected);
//   }
//
//   Future _showNotification() async {
//     var androidDetails = new AndroidNotificationDetails(
//         "Channel ID", "Channel Name", "Channel Description",
//         importance: Importance.Max);
//     var iSODetails = new IOSNotificationDetails();
//     var generalNotificationDetails =
//         new NotificationDetails(androidDetails, iSODetails);
//
//     // await fltrNotification.show(
//     //     0, "Task", "You created a Task", generalNotificationDetails, payload: "Task");
//     var scheduledTime;
//     if (_selectedParam == "Hour") {
//       scheduledTime = DateTime.now().add(Duration(hours: val));
//     } else if (_selectedParam == "Minutes") {
//       scheduledTime = DateTime.now().add(Duration(minutes: val));
//     } else {
//       scheduledTime = DateTime.now().add(Duration(seconds: val));
//     }
//     fltrNotification.periodicallyShow(
//         0,
//         'Good Morning!',
//         "Did you have breakfast?",
//         RepeatInterval.Daily,
//         generalNotificationDetails); // repeat notification
//     fltrNotification.schedule(
//         1, "Good Wallet", task, scheduledTime, generalNotificationDetails);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: TextField(
//             decoration: InputDecoration(border: OutlineInputBorder()),
//             onChanged: (_val) {
//               task = _val;
//             },
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             DropdownButton(
//               value: _selectedParam,
//               items: [
//                 DropdownMenuItem(
//                   child: Text("Seconds"),
//                   value: "Seconds",
//                 ),
//                 DropdownMenuItem(
//                   child: Text("Minutes"),
//                   value: "Minutes",
//                 ),
//                 DropdownMenuItem(
//                   child: Text("Hour"),
//                   value: "Hour",
//                 ),
//               ],
//               hint: Text(
//                 "Select Your Field.",
//                 style: TextStyle(
//                   color: Colors.black,
//                 ),
//               ),
//               onChanged: (_val) {
//                 setState(() {
//                   _selectedParam = _val;
//                 });
//               },
//             ),
//             DropdownButton(
//               value: val,
//               items: [
//                 DropdownMenuItem(
//                   child: Text("1"),
//                   value: 1,
//                 ),
//                 DropdownMenuItem(
//                   child: Text("2"),
//                   value: 2,
//                 ),
//                 DropdownMenuItem(
//                   child: Text("3"),
//                   value: 3,
//                 ),
//                 DropdownMenuItem(
//                   child: Text("4"),
//                   value: 4,
//                 ),
//               ],
//               hint: Text(
//                 "Select Value",
//                 style: TextStyle(
//                   color: Colors.black,
//                 ),
//               ),
//               onChanged: (_val) {
//                 setState(() {
//                   val = _val;
//                 });
//               },
//             ),
//           ],
//         ),
//         RaisedButton(
//           onPressed: _showNotification,
//           child: new Text('Set Task With Notification'),
//         )
//       ],
//     );
//   }
//
//   Future notificationSelected(String payload) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Text("Notification Clicked $payload"),
//       ),
//     );
//   }
// }
//
// class notifyPage extends StatefulWidget {
//   @override
//   _notifyPageState createState() => _notifyPageState();
// }
//
// class _notifyPageState extends State<notifyPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             //Background Gradient Color
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
//               ),
//             ),
//             child: SafeArea(child: Notification())));
//   }
// }
