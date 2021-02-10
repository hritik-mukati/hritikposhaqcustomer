import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dproject/Categories.dart';

import 'package:dproject/Products.dart';
import 'package:dproject/WishList.dart';
class practice extends StatefulWidget {
  @override
  _practiceState createState() => _practiceState();
}

class _practiceState extends State<practice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
          ),
          FlatButton(
            child: Text("Products"),
            onPressed: (){
              print("PRODUCT PAGE");
              Fluttertoast.showToast(msg: "Products page..");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Products('23')));
            },
          ),
          FlatButton(
            child: Text("Categories"),
            onPressed: (){
              print("Categories");
              Fluttertoast.showToast(msg: "Categories..");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Categories()));
            },
          ),
          FlatButton(
            child: Text("Login"),
            onPressed: (){
              Navigator.pushNamed(context, "/Login");
            },
          ),
          FlatButton(
            child: Text("WishList"),
            onPressed: (){
              print("WishList");
              Fluttertoast.showToast(msg: "Wishlist page..");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WishList()));
            },
          ),
        ],
      ),
    );
  }
}
