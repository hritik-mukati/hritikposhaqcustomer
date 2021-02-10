import 'dart:convert';
import 'package:dproject/FinalPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Constants.dart';

class PaymentScreen extends StatefulWidget {
  final String amount;
  var order;
  PaymentScreen({this.amount, this.order});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;
  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;
  String ORDER_ID = null;

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'>" +
        "<input type='hidden' name='orderID' value='$ORDER_ID'/>" +
        "<input  type='hidden' name='custID' value='${ORDER_DATA["custID"]}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${ORDER_DATA["custEmail"]}' />" +
        "<input type='hidden' name='custPhone' value='${ORDER_DATA["custPhone"]}' />" +
        "</form> </body> </html>";
  }

  var decodedJSON;
  void getData() {
    _webController.evaluateJavascript("document.body.innerText").then((data) {
      decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      print(responseJSON.toString());
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => FinalPage(ORDER_ID)));

        if (checksumResult == 0) {
          _responseStatus = STATUS_SUCCESSFUL;
        } else {
          _responseStatus = STATUS_CHECKSUM_FAILED;
        }
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState(() {});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        {
          addPaytmOrderID(ORDER_ID);
          // return PaymentSuccessfulScreen();
          break;
        }
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return PaymentSuccessfulScreen();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSp();
    print(widget.order);
  }

  String customer_id = "", name = "";
  getSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // login = prefs.getBool("login")??false;
      customer_id = prefs.getString("customer_id") ?? "0";
      name = prefs.getString("name") ?? "Guest";
      ORDER_ID = customer_id + 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webController = controller;
                _webController.loadUrl(
                    new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                        .toString());
              },
              onPageFinished: (page) {
                print("------------------PAGE--------------------");
                print(page);
                if (page.contains("/process")) {
                  if (_loadingPayment) {
                    this.setState(() {
                      _loadingPayment = false;
                    });
                  }
                }
                if (page.contains("/paymentReceipt")) {
                  getData();
                }
              },
            ),
          ),
          (_loadingPayment)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(),
          (_responseStatus != STATUS_LOADING)
              ? Center(child: getResponseScreen())
              : Center()
        ],
      )),
    );
  }

  void addPaytmOrderID(
    var order_id,
  ) async {
    print(order_id);
    http.Response respose = await http.post(API.updatePaytm,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'authkey': API.key,
          'paytm_order_id': ORDER_ID,
          'order': widget.order,
        }));
    print(respose.body);
    setState(() {
      if (respose.statusCode == 200) {
        var responsed = json.decode(respose.body);
        if (responsed['status'] == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FinalPage(ORDER_ID)));
        } else {
          Fluttertoast.showToast(msg: "Error Occure in adding data");
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NetworkErrorScreen(ORDER_ID, widget.order)));
      }
    });
  }
}

class NetworkErrorScreen extends StatelessWidget {
  String ORDER_ID;
  var order;
  NetworkErrorScreen(this.ORDER_ID, this.order);
  @override
  Widget build(BuildContext context) {
    void addPaytmOrderID(
      var order_id,
    ) async {
      print(order_id);
      http.Response respose = await http.post(API.updatePaytm, body: {
        'authkey': API.key,
        'paytm_order_id': ORDER_ID,
        'order': order,
      });
      print(respose.body);
      if (respose.statusCode == 200) {
        var responsed = json.decode(respose.body);
        if (responsed['status'] == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FinalPage(ORDER_ID)));
        } else {
          Fluttertoast.showToast(msg: "Error Occure in adding data");
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NetworkErrorScreen(ORDER_ID, order)));
      }
    }

    return Container(
      color: Constants.ACCENT_COLOR,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Do not close the Application,please relode the page!"),
          RaisedButton(
            child: Text(
              "Relode",
              style: TextStyle(color: Constants.ACCENT_COLOR),
            ),
            color: Constants.PRIMARY_COLOR,
            onPressed: () {
              addPaytmOrderID(ORDER_ID);
            },
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Great! Hurray",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Thank you making the payment!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "OOPS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment was not successful, Please try again Later!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oh Snap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
