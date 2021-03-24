import 'package:flutter/material.dart';
import 'Constants.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:50.0),
            child:Column(
              children: <Widget>[
                Center(child: Text(Constants.APP_NAME.toUpperCase(),style: TextStyle(letterSpacing:3,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor,fontSize: 28))),
                Expanded(
                  child:Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Name",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
