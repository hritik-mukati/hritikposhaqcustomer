import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dproject/BannerPage.dart';
import 'package:dproject/Detailed.dart';
import 'package:dproject/MyCart.dart';
import 'package:dproject/NewProducts.dart';
import 'package:dproject/ProductByCatName.dart';
import 'package:dproject/Search.dart';
import 'package:dproject/WishList.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dproject/Constants.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'package:http/http.dart' as http;
import 'DeepUrl.dart';
import 'Products.dart';
import 'ProgressDailog.dart';
import 'login.dart';
import 'my_order.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loadcat = false, login = false, lod = true;
  String customer_id, name;
  int semain = 0, sesub = 0, sesusub = 0;
  List<String> list1 = List();
  List<String> list2 = List();
  List<Map> list3 = List();
  var responsed;
  List<dynamic> imageList = List<dynamic>();
  bool getimg = false;
  @override
  void initState() {
    super.initState();
    getSp(0);
    // addimages();// fetch cats
    fetchInnofbanner();
  }

  getSp(int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool("login") ?? false;
      customer_id = prefs.getString("customer_id") ?? "0";
      name = prefs.getString("name") ?? "Guest";
    });
    if (i == 0) {
      getCats(); //
    }
  }

  // fetching and changing category...
  getCats() async {
    http.Response response = await http.post(API.fetch_all_cat, body: {
      'authkey': API.key,
    });
    print(response.body);
    setState(() {
      loadcat = true;
      responsed = json.decode(response.body);
      if (responsed['status'] == 2) {
        print("Mains");
        for (int i = 0; i < responsed['result']['main'].length; i++) {
          print(responsed['result']['main'][i]['cat_name']);
        }
        print("First Subs");
        for (int i = 0;
            i < responsed['result']['main'][0]['sub_cat_array'].length;
            i++) {
          // print(responsed['result']['main'][0]['sub_cat_array'].length);
          print(responsed['result']['main'][0]['sub_cat_array'][i]['cat_name']);
        }
        print("Second Subs");
        for (int i = 0;
            i <
                responsed['result']['main'][0]['sub_cat_array'][1]
                        ['susub_cat_array']
                    .length;
            i++) {
          print(responsed['result']['main'][0]['sub_cat_array'][1]
              ['susub_cat_array'][i]['cat_name']);
        }
        for (int i = 0; i < responsed['result']['main'].length; i++) {
          list1.add(responsed['result']['main'][i]['cat_name'].toString());
        }
        for (int i = 0;
            i < responsed['result']['main'][0]['sub_cat_array'].length;
            i++) {
          list2.add(responsed['result']['main'][0]['sub_cat_array'][i]
                  ['cat_name']
              .toString());
        }
        list3 = List();
        for (int i = 0;
            i <
                responsed['result']['main'][0]['sub_cat_array'][0]
                        ['susub_cat_array']
                    .length;
            i++) {
          var t = Map<String, String>();
          // print(i.toString()+ "  - "+description[i].value);
          t["cat_id"] = responsed['result']['main'][0]['sub_cat_array'][0]
                  ['susub_cat_array'][i]['cat_id']
              .toString();
          t["cat_name"] = responsed['result']['main'][0]['sub_cat_array'][0]
                  ['susub_cat_array'][i]['cat_name']
              .toString();
          t["cat_img"] = responsed['result']['main'][0]['sub_cat_array'][0]
                  ['susub_cat_array'][i]['img_url']
              .toString();
          list3.add(t);
          // print(list3);
        }
        print(list3);
      }
    });
  }

  select_subcat(String index, String type) {
    setState(() {
      if (type == "0") {
        list2 = List();
        sesub = 0;
        for (int i = 0;
            i <
                responsed['result']['main'][int.parse(index.toString())]
                        ['sub_cat_array']
                    .length;
            i++) {
          list2.add(responsed['result']['main'][int.parse(index.toString())]
                  ['sub_cat_array'][i]['cat_name']
              .toString());
        }
        print("List 2: ");
        print(list2);
        list3 = List();
        for (int i = 0;
            i <
                responsed['result']['main'][semain]['sub_cat_array'][0]
                        ['susub_cat_array']
                    .length;
            i++) {
          var t = Map<String, String>();
          // print(i.toString()+ "  - "+description[i].value);
          t["cat_id"] = responsed['result']['main'][semain]['sub_cat_array'][0]
                  ['susub_cat_array'][i]['cat_id']
              .toString();
          t["cat_name"] = responsed['result']['main'][semain]['sub_cat_array']
                  [0]['susub_cat_array'][i]['cat_name']
              .toString();
          t["cat_img"] = responsed['result']['main'][semain]['sub_cat_array'][0]
                  ['susub_cat_array'][i]['img_url']
              .toString();
          list3.add(t);
          // print(list3);
        }
        print("List 3: ");
        print(list3);
      }
      if (type == "1") {
        list3 = List();
        for (int i = 0;
            i <
                responsed['result']['main'][semain]['sub_cat_array'][sesub]
                        ['susub_cat_array']
                    .length;
            i++) {
          var t = Map<String, String>();
          // print(i.toString()+ "  - "+description[i].value);
          t["cat_id"] = responsed['result']['main'][semain]['sub_cat_array']
                  [sesub]['susub_cat_array'][i]['cat_id']
              .toString();
          t["cat_name"] = responsed['result']['main'][semain]['sub_cat_array']
                  [sesub]['susub_cat_array'][i]['cat_name']
              .toString();
          t["cat_img"] = responsed['result']['main'][semain]['sub_cat_array']
                  [sesub]['susub_cat_array'][i]['img_url']
              .toString();
          list3.add(t);
          print(list3);
        }
        print("List 3: ");
        print(list3);
      }
    });
    // print(list2);
  } //Fetch Category

  // fetching and changing category...
  bool bannerl = false, trError = false;
  bool trload = false;
  int trlength;
  var trending;
  getTrending() async {
    try {
      http.Response response = await http.post(API.trending, body: {
        'authkey': API.key,
      });
      print("trenging");
      print(response.body);
      print("trenging");
      setState(() {
        getimg = true;
        trending = json.decode(response.body);
        if (trending['status'] == 2) {
          trlength = trending['result'].length;
          if (trlength > 8) {
            trlength = 8;
          }
          setState(() {
            trload = true;
          });
        } else {
          trload = true;
          trError = true;
        }
      });
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      setState(() {
        trload = true;
        trError = true;
      });
    }
  }

  fetchInnofbanner() async {
    try {
      http.Response response = await http.post(API.fetchbanner, body: {
        'authkey': API.key,
      });
      print(response.body);
      setState(() {
        getTrending();
        getimg = true;
        var responsed = json.decode(response.body);
        if (responsed['status'] == 2) {
          for (int i = 0; i < responsed['result'].length; i++) {
            print("INfo banners:");
            print(responsed['result'][i]['img_url'].toString());
            imageList.add(
                (NetworkImage(responsed['result'][i]['img_url'].toString())));
          }
        } else {
          imageList.add(NetworkImage(
              "https://t3.ftcdn.net/jpg/02/20/14/38/360_F_220143804_fc4xRygvJ8bn8JPQumtHJieDN4ORNyjs.jpg"));
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      imageList.add(
          "https://t3.ftcdn.net/jpg/02/20/14/38/360_F_220143804_fc4xRygvJ8bn8JPQumtHJieDN4ORNyjs.jpg");
    }
  }

  Widget image_slider(var Context) {
    Container(
      height: 200,
      child: getimg
          ? Carousel(
              boxFit: BoxFit.fill,
              // images: imageList,
              autoplay: true,
              showIndicator: true,
              dotSize: 5.0,
              dotSpacing: 20.0,
              dotBgColor: Constants.ACCENT_COLOR,
              indicatorBgPadding: 0.0,
              dotColor: Constants.PRIMARY_COLOR,
              images: [
                NetworkImage(
                    'https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
                NetworkImage(
                    'https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
              ],
            )
          : Center(
              child: ProgressDailog().Progress(context),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Constants
            .PRIMARY_COLOR, //Changing this will change the color of the TabBar
        accentColor: Constants.ACCENT_COLOR,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Constants.ACCENT_COLOR,
          body: TabBarView(
            children: [
              homeScreen(context),
              new Container(
                child: loadcat
                    ? Scaffold(
                        body: Container(
                          color: Color(0xffF5F5F5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 40,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.notifications_none,
                                                color: Constants.PRIMARY_COLOR,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(_createRoute());
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 35,
                                              color: Colors.white12,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Search())).then(
                                                      (value) => getSp(1));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.search,
                                                        color: Colors.grey),
                                                    Text(
                                                      " Search",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 40,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.redeem,
                                                color: Constants.PRIMARY_COLOR,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyCart()))
                                                    .then((value) => getSp(1));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  color: Colors.white,
                                  child: Center(
                                    child: ListView.builder(
                                        itemCount: list1.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                top: 2,
                                                bottom: 2,
                                                right: 5),
                                            child: Container(
//                          height:40,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    semain = index;
                                                    print(semain);
                                                    select_subcat(
                                                        semain.toString(), "0");
                                                  });
                                                },
                                                child: Center(
                                                    child: Text(
                                                  list1[index],
                                                  style: TextStyle(
                                                      fontSize: semain == index
                                                          ? 20
                                                          : 18,
                                                      fontWeight: semain ==
                                                              index
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      decoration:
                                                          semain == index
                                                              ? TextDecoration
                                                                  .underline
                                                              : TextDecoration
                                                                  .none),
                                                )),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
//              color: Colors.yellow,
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, bottom: 5, left: 8, right: 8),
                                      child: Container(
                                        color: Colors.white,
                                        child: ListView.builder(
                                            itemCount: list2.length,
//                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.0,
                                                    top: 1,
                                                    bottom: 22,
                                                    right: 5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      sesub = index;
                                                      print(sesub);
                                                      select_subcat(
                                                          index.toString(),
                                                          "1");
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      list2[index],
                                                      style: TextStyle(
                                                          fontSize: sesub ==
                                                                  index
                                                              ? 19
                                                              : 17,
                                                          fontWeight:
                                                              sesub ==
                                                                      index
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                          decoration: sesub ==
                                                                  index
                                                              ? TextDecoration
                                                                  .underline
                                                              : TextDecoration
                                                                  .none),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: list3.length != 0
                                          ? Container(
                                              // color: Color(0xffF5F5F5),
                                              color: Colors.white,
                                              child: GridView.builder(
                                                itemCount: list3.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 200 / 200,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return new Card(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Products(list3[index]
                                                                            [
                                                                            'cat_id']
                                                                        .toString()))).then(
                                                            (value) =>
                                                                getSp(1));
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: list3[index][
                                                                        'cat_img'] !=
                                                                    null
                                                                ? Image.network(
                                                                    list3[index]
                                                                        [
                                                                        'cat_img'],
                                                                    height: 80,
                                                                    width: 80)
                                                                : Image.asset(
                                                                    "images/no-img.png",
                                                                    height: 80,
                                                                    width: 80),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: Text(
                                                              list3[index]
                                                                  ['cat_name'],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              color: Constants.ACCENT_COLOR,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: 150,
                                                      width: 150,
                                                      child: Image.asset(
                                                          "images/empty.png")),
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                  ),
                                                  Text(
                                                    "No Categories Found!",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                ],
                              )),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child:
                            Center(child: ProgressDailog().Progress(context))),
              ),
              new Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  title: Text(" "),
                  backgroundColor: Constants.ACCENT_COLOR,
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.redeem,
                        color: Constants.PRIMARY_COLOR,
                      ),
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyCart()))
                            .then((value) => getSp(1));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Constants.PRIMARY_COLOR),
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()))
                            .then((value) => getSp(1));
                      },
                    ),
                  ],
                ),
                body: Container(
                    color: Colors.grey[100],
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            color: Constants.ACCENT_COLOR,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[400],
                                    radius: 35,
                                    child: Text(
                                      login ? name.substring(0, 1) : "P",
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Constants.ACCENT_COLOR),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (login == false) {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login(0)))
                                              .then((value) => getSp(1));
                                        } else if (login == true) {
                                          showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text("Log Out ?"),
                                              actions: [
                                                RaisedButton(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .ACCENT_COLOR),
                                                  ),
                                                  color:
                                                      Constants.PRIMARY_COLOR,
                                                  onPressed: () {
                                                    setState(() {
                                                      lod = false;
                                                    });
                                                    logout();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                RaisedButton(
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .ACCENT_COLOR),
                                                  ),
                                                  color:
                                                      Constants.PRIMARY_COLOR,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        // width: 87,
                                        color: Constants.PRIMARY_COLOR,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Center(
                                                child: Row(
                                              children: [
                                                Text(
                                                  login
                                                      ? lod
                                                          ? name
                                                          : "Wait a Sec.."
                                                      : "LOG IN ",
                                                  style: TextStyle(
                                                      color: Constants
                                                          .ACCENT_COLOR,
                                                      fontSize: 16),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Constants.ACCENT_COLOR,
                                                  size: 18,
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            color: Constants.ACCENT_COLOR,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "My Orders",
                                      style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyOrder(
                                                                "All Orders",
                                                                "0")))
                                                .then((value) => getSp(1));
                                          },
                                          child: Container(
                                            height: 80,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50) /
                                                2,
                                            color: Colors.white38,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.credit_card,
                                                  size: 30,
                                                ),
                                                Text(
                                                  "All Orders",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyOrder(
                                                                "Processing",
                                                                "1")))
                                                .then((value) => getSp(1));
                                          },
                                          child: Container(
                                            height: 80,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50) /
                                                2,
                                            color: Colors.white38,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.card_giftcard,
                                                  size: 30,
                                                ),
                                                Text(
                                                  "Processing",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyOrder(
                                                              "Shipped", "2")))
                                              .then((value) => getSp(1));
                                        },
                                        child: Container(
                                          height: 80,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          color: Colors.white38,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.airport_shuttle,
                                                size: 30,
                                              ),
                                              Text(
                                                "Shipped",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyOrder(
                                                              "return", "5")))
                                              .then((value) => getSp(1));
                                        },
                                        child: Container(
                                          height: 80,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          color: Colors.white38,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.assignment_return,
                                                size: 30,
                                              ),
                                              Text(
                                                "Returns",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Constants.ACCENT_COLOR,
                          // height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("More Services",
                                      style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg: "Support");
                                        },
                                        child: Container(
                                          height: 80,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          color: Colors.white38,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.help_outline,
                                                size: 30,
                                              ),
                                              Text(
                                                "Support",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AppShare(context);
                                        },
                                        child: Container(
                                          height: 80,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          color: Colors.white38,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.mobile_screen_share,
                                                size: 30,
                                              ),
                                              Text(
                                                "Share",
                                                style: TextStyle(fontSize: 20),
                                              )
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
                        ),
                      ],
                    )),
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.dashboard),
              ),
              Tab(
                icon: new Icon(Icons.person),
              ),
            ],
            labelColor: Constants.PRIMARY_COLOR,
            indicatorColor: Constants.PRIMARY_COLOR,
            unselectedLabelColor: Colors.grey[500],
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            // indicatorColor: Colors.red,
          ),
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    await preferences.clear();
    preferences.setString("token", token);
    print("token: " + token);
    http.Response response = await http.post(API.logout, body: {
      'authkey': API.key,
      'device_token': token,
    });
    setState(() {
      var responsed = json.decode(response.body);
      if (responsed['status'] == 2) {
        lod = true;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login(0)));
      } else {
        lod = true;
        Fluttertoast.showToast(msg: "Network Error!!");
      }
    });
    getSp(1);
  }

  Widget homeScreen(var context) {
    var trends = 10;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<int> arr = [0, 2, 4, 6];
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Constants.ACCENT_COLOR,
        leading: IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: Constants.PRIMARY_COLOR,
          ),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        ),
        title: Center(
            child: Text(
          Constants.APP_NAME,
          style: TextStyle(color: Constants.PRIMARY_COLOR),
        )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Constants.PRIMARY_COLOR,
            ),
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()))
                  .then((value) => getSp(1));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.redeem,
              color: Constants.PRIMARY_COLOR,
            ),
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCart()))
                  .then((value) => getSp(1));
            },
          ),
        ],
      ),
      body: Container(
        color: Constants.ACCENT_COLOR,
        child: ListView(
          children: [
            SizedBox(
              width: width,
              height: height / 3.5,
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 0.0),
                child: getimg
                    ? Carousel(
                        boxFit: BoxFit.fill,
                        images: imageList,
                        autoplay: true,
                        showIndicator: true,
                        dotSize: 5.0,
                        dotSpacing: 20.0,
                        dotBgColor: Constants.ACCENT_COLOR,
                        indicatorBgPadding: 0.0,
                        dotColor: Constants.PRIMARY_COLOR,
                      )
                    : Center(
                        child: ProgressDailog().Progress(context),
                      ),
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Be New",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: [
                        Image.network(
                          "https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/1510828/2020/1/20/8d5ca9e9-b3f1-4c14-baab-51e7300993251579509422884-SASSAFRAS-Women-Black-Solid-Styled-Back-Top-3301579509421263-1.jpg",
                          fit: BoxFit.cover,
                          height: 220,
                        ),
                        Container(
                          height: 220,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "New In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: [
                        Image.network(
                          "https://images-na.ssl-images-amazon.com/images/I/41%2B2BytOpgL._SX425_.jpg",
                          fit: BoxFit.fill,
                          height: 260,
                        ),
                        Container(
                          height: 260,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewProducts()));
                                  },
                                  color: Colors.black,
                                  child: Text(
                                    "View More >",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Text(
                "Offers",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BannerPage("80% OFF", "0")));
                },
                child: Image.asset("images/Dashbord/offer1.PNG")),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BannerPage("60% OFF", "0")));
                },
                child: Image.asset("images/Dashbord/offer2.PNG")),
            Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Text(
                "Fashion Trends",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )),
            if (trload)
              if (trError)
                Center(
                  child: Text("NO Data Found!"),
                )
              else
                for (int i = 0; i < trlength; i = i + 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                            print(
                              "printing" +
                                  trending['result'][i]['p_id'].toString(),
                            );
                            String p_id =
                                trending['result'][i]['p_id'].toString();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detailed(p_id)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                                  child: Image.network(
                                    trending['result'][i]['img'].toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    trending['result'][i]['name'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                            print(
                              "printing" +
                                  trending['result'][i + 1]['p_id'].toString(),
                            );
                            String p_id =
                                trending['result'][i + 1]['p_id'].toString();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detailed(p_id)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                                  child: Image.network(
                                    trending['result'][i + 1]['img'].toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    trending['result'][i + 1]['name']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
            else
              ProgressDailog().Progress(context),
            Container(
              height: 20,
            ),
            // Image.network("https://drive.google.com/file/d/1xRFftDMZvASVvOOEn76S22oPimOyOV_w/view?usp=sharing")
            Container(
              color: Colors.amber,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductByCatName("Western Wear")));
                            },
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Western Dress".toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    // Image.network("https://n.nordstrommedia.com/ImageGallery/store/product/Zoom/12/_107612912.jpg",)
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset("images/004.png")),
                                  ],
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductByCatName("Shorts & Skirts")));
                            },
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Skirts".toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset("images/006.png")),
                                    // Image.network("https://n.nordstrommedia.com/ImageGallery/store/product/Zoom/12/_107612912.jpg",)
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductByCatName(
                                          "Sweaters & Sweatshirts")));
                            },
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Sweaters".toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset("images/005.png")),
                                    // Image.network("https://n.nordstrommedia.com/ImageGallery/store/product/Zoom/12/_107612912.jpg",)
                                  ],
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductByCatName("Foot-wear")));
                            },
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Foot-Wear".toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset("images/002.png")),
                                    // Image.network("https://n.nordstrommedia.com/ImageGallery/store/product/Zoom/12/_107612912.jpg",)
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductByCatName("Ethnic Dresses")));
                            },
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Ethnic Dress".toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset("images/003.png")),
                                    // Image.network("https://n.nordstrommedia.com/ImageGallery/store/product/Zoom/12/_107612912.jpg",)
                                  ],
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductByCatName("Party Dresses")));
                            },
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      "Party Dress".toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset("images/001.png")),
                                    // Image.network("https://n.nordstrommedia.com/ImageGallery/store/product/Zoom/12/_107612912.jpg",)
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void share(type, id, desc, title, img) async {
  var url = await DPUrl.buildUrl(type, id, desc, title, img);
  print(url.toString());
  Share.share(url.toString(), subject: "Sharin Details");
}

void AppShare(context) {
  final RenderBox box = context.findRenderObject();
  Share.share(
      "https://play.google.com/store/apps/details?id=com.poshaq.customer",
      subject: "Share Poshaq",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Notification(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  String customer_id, name;
  bool login = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSp();
  }

  getSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getBool("login") ?? false;
    customer_id = prefs.getString("customer_id") ?? "0";
    print("customer_id: " + customer_id);
    name = prefs.getString("name") ?? "0"; //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.ACCENT_COLOR,
        elevation: 0.1,
        iconTheme: IconThemeData(
          color: Constants.PRIMARY_COLOR,
        ),
        title: Text(
          "Messages",
          style: TextStyle(color: Constants.PRIMARY_COLOR),
        ),
      ),
      body: Container(
        color: Constants.ACCENT_COLOR,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[400],
                  width: 0.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyOrder("My Orders", "0")));
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 20, child: Icon(Icons.list)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Orders",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "The latest status of your orders,Updates in time!",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[400],
                  width: 0.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  login
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WishList()))
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login(0)));
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 20, child: Icon(Icons.favorite_border)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Wishlist",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "The items you want to buy!",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[400],
                  width: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
