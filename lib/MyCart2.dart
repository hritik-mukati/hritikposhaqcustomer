import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCart2 extends StatefulWidget {
  @override
  _MyCart2State createState() => _MyCart2State();
}

class _MyCart2State extends State<MyCart2> {
  bool login = false,loding = false, no_data=false;
  var Custom_cart;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
  }
  getSP()async{
    print("In sp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getBool('login')??false;
    Custom_cart = prefs.getString('Custom_cart') ?? [];
    if(Custom_cart.length!=0){
      Custom_cart = jsonDecode(Custom_cart);
    }
    if(login){
      print("login "+ login.toString());
      get_cart();
    }else{
      print("login "+ login.toString());
      if(Custom_cart.length!=0){
        print("data in ofline cart");
        print(Custom_cart);
        // get_static_cart();
      }else{
        print("in cart empty, and login false");
        setState(() {
          loding = true;
          no_data = true;
        });
      }
    }
  }
  get_cart()async{
    print("Calling get cart!!");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("MyCart2")),
    );
  }
}
