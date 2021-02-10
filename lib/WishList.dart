import 'dart:convert';

import 'package:dproject/Constants.dart';
import 'package:dproject/ProgressDailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  var wishlist = [];
  bool load = false, error = false, nodata = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
  }

  String customer_id;
  getSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString("customer_id");
    print("Customer_id: " + customer_id);
    getwishlist();
  }

  getwishlist() async {
    try {
      http.Response response = await http.post(API.fetch_wishlist, body: {
        'authkey': API.key,
        'customer_id': customer_id,
      });
      print(response.body);
      setState(() {
        var responsed = json.decode(response.body);
        if (responsed['status'] == 2) {
          load = true;
          nodata = false;
          error = false;
          wishlist = responsed['result'];
        } else if (responsed['status'] == 1) {
          load = true;
          nodata = true;
          error = false;
        } else {
          load = true;
          error = true;
        }
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        load = true;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("WishList")),
        actions: [
          Icon(
            Icons.redeem,
            color: Constants.ACCENT_COLOR,
          ),
        ],
      ),
      body: load
          ? error
              ? Container(
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Network Error!! please Reload",
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      FlatButton(
                        color: Colors.black,
                        child: Text(
                          "Relod",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          getwishlist();
                        },
                      ),
                    ],
                  ),
                )
              : nodata
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Constants.ACCENT_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 150,
                              width: 150,
                              child: Image.asset("images/empty.png")),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Text(
                            "No Products Found!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      // color: Constants.PRIMARY_COLOR,
                      child: ListView.builder(
                        itemCount: wishlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  wishlist[index]['img_url']),
                                            ),
                                          ),
                                          height: 150,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          height: 150,
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    wishlist[index]['name']
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(" "),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "\u20B9" +
                                                          wishlist[index]
                                                              ['price'],
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text("   "),
                                                    Text(wishlist[index]['mrp'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough)),
                                                  ],
                                                ),
                                                Text(" "),
                                                Row(
                                                  children: [
                                                    Text("Color : "),
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      color: Color(int.parse(
                                                          "0xff" +
                                                              wishlist[index][
                                                                      'color_code']
                                                                  .toString())),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      delete(wishlist[index]['wishlist_id']
                                          .toString());
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
          : ProgressDailog().Progress(context),
    );
  }

  delete(String id) async {
    http.Response response = await http.post(API.delete_wishlist, body: {
      'authkey': API.key,
      'wishlist_id': id,
    });
    print(response.body);
    setState(() {
      var responsed = json.decode(response.body);
      if (responsed['status'] == 2) {
        Fluttertoast.showToast(msg: responsed['message']);
        getwishlist();
      } else {
        Fluttertoast.showToast(msg: responsed['message']);
      }
    });
  }
}
