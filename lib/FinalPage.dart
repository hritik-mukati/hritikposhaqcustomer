import 'package:dproject/Constants.dart';
import 'package:dproject/Dashboard.dart';
import 'package:flutter/material.dart';

class FinalPage extends StatefulWidget {
  String id;

  FinalPage(String this.id);
  // FinalPage(String this.id);
  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("In final page");
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Constants.ACCENT_COLOR,
          ),
          Center(
            child: Card(
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 400,
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 15, right: 15, bottom: 20),
                      child: Text(
                        "Thank You ",
                        style: TextStyle(
                            fontSize: 30,
                            color: Constants.ACCENT_COLOR,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text("Your order has been placed. Refrence # " + widget.id,
                        style: TextStyle(
                            fontSize: 15,
                            color: Constants.ACCENT_COLOR,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Icon(
                        Icons.check_circle,
                        size: 100,
                        color: Constants.ACCENT_COLOR,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Back to Home",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Constants.ACCENT_COLOR,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.arrow_forward,
                            color: Constants.ACCENT_COLOR,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
