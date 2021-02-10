import 'dart:convert';
import 'package:dproject/PaymentMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Address.dart';
import 'Constants.dart';
import 'ProgressDailog.dart';

class CheckOut extends StatefulWidget {
  String address, name, pincode, add_id, mobile;
  CheckOut(String names, String addressed, String this.pincode,
      String this.add_id, String this.mobile) {
    address = addressed;
    name = names;
    print(add_id);
    print(name);
    print(address);
    print(pincode);
  }

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  double total = 0;
  bool cod = false, delivery = false, load = false;
  String name, email, mobile, customer_id;
  double price = 0, mrp = 0, del_chrg = 65.0, st_price = 0;
  var responsed;
  bool cartdata = true, loader = true;
  getStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
      mobile = widget.mobile;
      customer_id = prefs.getString("customer_id");
      getcart(customer_id);
    });
  }

  void getcart(String customer_id) async {
    final http.Response response =
        await http.post(API.fetch_cart, headers: <String, String>{
      'Content_Type': 'application/json; charset=UTF-8'
    }, body: {
      'customer_id': customer_id,
      'authkey': API.key,
    });
    print(response.body);
    if (response.statusCode == 200) {
      total = 0;
      setState(() {
        cartdata = true;
//        print(response.body);
        responsed = json.decode(response.body);
        for (int i = 0; i < responsed['result'].length; i++) {
          price = price +
              int.parse(responsed['result'][i]['quantity']) *
                  int.parse(responsed['result'][i]['price']);
          st_price = price;
        }
        if (price < 999.0) {
          price = price + del_chrg;
        }
        price = price + 20;
//        print(price);
        if (responsed["status"] == 0) {
//          dataincart = 0;
        }
        if (responsed["status"] == 2) {
//          dataincart = 1;
          setState(() {
            print(responsed['result'].length);
            for (int i = 0; i < responsed["result"].length; i++) {
              mrp = mrp +
                  double.parse(responsed['result'][i]['mrp']) *
                      double.parse(responsed['result'][i]['quantity']);
            }
            getcoddel(widget.pincode);
            print(total);
          });
        } else {
          setState(() {
            Fluttertoast.showToast(msg: "Error in getting data!1");
          });
        }
      });
    }
  }

  getcoddel(String pincode) async {
    print("Checking Pincode: " + pincode);
    http.Response response = await http.post(API.delivery, body: {
      'authkey': API.key,
      'postcode': pincode,
    });
    // print("getcode: ");
    // print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        load = true;
        var responsed = json.decode(response.body);
        if (responsed['status'] == 2) {
          cod = responsed['result'][0]['cod'] == "1" ? true : false;
          delivery = responsed['result'][0]['delivery'] == "1" ? true : false;
        } else {
          cod = false;
          delivery = false;
        }
        print("cod: " + cod.toString());
        print("delivery: " + delivery.toString());
      });
    } else {
      Fluttertoast.showToast(
          msg: "Network Error!!", backgroundColor: Colors.red);
      setState(() {
        load = true;
      });
    }
  }

//   placeorder(String customer_id , String address , String added_by)async{
//     final http.Response response = await http.post(
//         BaseUrl.selected + BaseUrl.addorder,
//         headers: <String, String>{
//           'Content_Type': 'application/json; charset=UTF-8'
//         },
//         body: {
//           'key':BaseUrl.key,
//           'customer_id': customer_id,
//           'address' : address,
//           'added_by' : added_by,
//           'contact' : mobile,
//           'name_for_delivery' : name,
//         });
//     if(response.statusCode==200);
// //    print(response.body);
//     var responsed = json.decode(response.body);
//     if(responsed['status']==1){
//       setState(() {
//         loader = true;
//       });
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HurrayPage(price)));
//     }else{
//       Fluttertoast.showToast(msg: "Error Occured plz try again!!");
//     }
//   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringToSF();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760);
    return load
        ? Scaffold(
            appBar: AppBar(
              title: Text("Order Summary"),
            ),
            body: cartdata
                ? Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height - 170,
                        child: ListView(
                          children: <Widget>[
                            Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setSp(12),
                                        top: ScreenUtil().setSp(10)),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          widget.name.toString(),
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(16)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(2),
                                        left: ScreenUtil().setWidth(12),
                                        right: ScreenUtil().setWidth(12)),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              widget.address,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(4),
                                        left: ScreenUtil().setWidth(12),
                                        right: ScreenUtil().setWidth(12)),
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            widget.pincode,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(16)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(8),
                                        left: ScreenUtil().setWidth(12),
                                        right: ScreenUtil().setWidth(12)),
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            widget.mobile,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(16)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(12),
                                            left: ScreenUtil().setWidth(12),
                                            right: ScreenUtil().setWidth(12)),
                                        child: Row(
                                          children: [
                                            delivery
                                                ? Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 18)
                                                : Icon(Icons.cancel,
                                                    color: Colors.red,
                                                    size: 18),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                delivery
                                                    ? "Delivery Available"
                                                    : "Delivery not Available",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: delivery
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(12),
                                            left: ScreenUtil().setWidth(12),
                                            right: ScreenUtil().setWidth(12)),
                                        child: Row(
                                          children: [
                                            cod
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 18,
                                                  )
                                                : Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                cod
                                                    ? "Available COD"
                                                    : "COD not Available",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: cod
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(12),
                                        left: ScreenUtil().setWidth(12),
                                        right: ScreenUtil().setWidth(12)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: ScreenUtil().setHeight(40),
                                      color: Theme.of(context).primaryColor,
                                      child: MaterialButton(
                                        child: Text(
                                          "Change or Add Address",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Address()));
                                          print("In addresss change....");
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(12),
                                    left: ScreenUtil().setWidth(12),
                                    right: ScreenUtil().setWidth(15)),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
//                          color:Colors.red,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width +
                                                    ScreenUtil().setWidth(40)) /
                                                2,
                                            child: Text("Products",
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(16)))),
                                        Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    ScreenUtil()
                                                        .setWidth(130)) /
                                                4,
//                          color:Colors.green,
                                            child: Text(
                                              "Qty",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16)),
                                            )),
                                        Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    ScreenUtil()
                                                        .setWidth(130)) /
                                                4,
//                          color:Colors.green,
                                            child: Text(
                                              "Price",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16)),
                                            )),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.blueGrey,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              ScreenUtil().setHeight(620),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: responsed['result'].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: ScreenUtil().setHeight(12),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
//                          color:Colors.red,
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width +
                                                              ScreenUtil()
                                                                  .setWidth(
                                                                      40)) /
                                                          2,
                                                      child: Text(
                                                          responsed['result']
                                                              [index]['name'],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14)))),
                                                  Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              ScreenUtil()
                                                                  .setWidth(
                                                                      130)) /
                                                          4,
//                          color:Colors.green,
                                                      child: Text(
                                                        responsed['result']
                                                            [index]['quantity'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14)),
                                                      )),
                                                  Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              ScreenUtil()
                                                                  .setWidth(
                                                                      130)) /
                                                          4,
//                          color:Colors.green,
                                                      child: Text(
                                                        (double.parse(responsed[
                                                                            'result']
                                                                        [index][
                                                                    'quantity']) *
                                                                double.parse(
                                                                    responsed['result']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'price']))
                                                            .floor()
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14)),
                                                      )),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                                child: Text(
                              "*Delivery Charges applicable on total amount less than 999",
                              style: TextStyle(color: Colors.red),
                            )),
                            Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5.0,
                                        left: ScreenUtil().setWidth(12)),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Amount Details",
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(16.0),
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.blueGrey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(12),
                                        left: ScreenUtil().setWidth(12),
                                        right: ScreenUtil().setWidth(30)),
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Amount",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                              Text(
                                                "\u20B9 $st_price",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(3),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Service Tax",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                              Text(
                                                "\u20B9 " + "20.0",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(3),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Delivery Charge",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                              Text(
                                                price < 999
                                                    ? "\u20B9 " +
                                                        del_chrg.toString()
                                                    : "Free",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(3),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Amount Payable",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                              Text(
                                                "\u20B9 $price",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                ),
                                              ),
                                            ],
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
                      ),
                      Container(
                        height: ScreenUtil().setHeight(62),
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).accentColor,
                        child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                // loader = false;
                              });
                              // placeorder(customer_id, widget.address, "1");

                              delivery
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentMode(
                                              price,
                                              cod,
                                              widget.name,
                                              widget.mobile,
                                              widget.address)))
                                  : Fluttertoast.showToast(
                                      msg: "Cannot Deliver to this address!",
                                      backgroundColor: Constants.PRIMARY_COLOR,
                                      textColor: Constants.ACCENT_COLOR);
                            },
                            child: loader
                                ? delivery
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text("Total: ",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(20),
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                                Text("\u20B9 $price",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(20),
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Constants.PRIMARY_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            height: 40.h,
                                            width: 125.w,
                                            child: Center(
                                              child: Text(
                                                " Place Order ",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(20),
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text("Total: ",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(18),
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                                Text("\u20B9 $price",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(18),
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Constants.PRIMARY_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            height: 40.h,
                                            width: 200.w,
                                            child: Center(
                                              child: Text(
                                                "Delivery Not Available",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                : Center(
                                    child: Text("Working On It.....",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20),
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  )),
                      ),
                    ],
                  )
                : Center(
                    child: ProgressDailog().Progress(context),
                  ),
          )
        : Scaffold(
            body: Container(
              color: Constants.ACCENT_COLOR,
              child: ProgressDailog().Progress(context),
            ),
          );
  }
}
