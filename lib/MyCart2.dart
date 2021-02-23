import 'package:flutter/material.dart';

class MyCart2 extends StatefulWidget {
  @override
  _MyCart2State createState() => _MyCart2State();
}

class _MyCart2State extends State<MyCart2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
  }
  getSP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("MyCart2")),
    );
  }
}
