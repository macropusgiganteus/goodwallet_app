import 'package:flutter/material.dart';

class ClassificationTest extends StatefulWidget {
  @override
  _ClassificationTestState createState() => _ClassificationTestState();
}

class _ClassificationTestState extends State<ClassificationTest> {
  String transactionName = '';
  String transactionClass;
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                // Text('This is test page'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: myController,
                    onChanged: (String str) {
                      setState(() {
                        transactionName = str;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Enter a transaction's name",
                        hintStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      Expanded(child: Text('Name :')),
                      Expanded(
                          child: Text(
                              transactionName == '' ? 'Name' : transactionName))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      Expanded(child: Text('Class :')),
                      Expanded(child: Text(transactionClass ?? 'Class Name'))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                    child: Text('Reset'),
                    onPressed: () {
                      setState(() {
                        transactionName = '';
                        myController.clear();
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
