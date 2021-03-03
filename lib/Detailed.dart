import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dproject/Dashboard.dart';
import 'package:dproject/MyCart.dart';
import 'package:dproject/imageViewer.dart';
import 'package:dproject/login.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'ProgressDailog.dart';
import 'dynamic_link_service.dart';

class Detailed extends StatefulWidget {
  String p_id;
  Detailed(this.p_id);

  @override
  _DetailedState createState() => _DetailedState();
}

class _DetailedState extends State<Detailed> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// Dynamic Link Object

  // bool _createLink = false;
  String _linkMessage;

  Future<void> initialCheck() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        setState(() {
          _linkMessage = deepLink.queryParameters['title'].toString();
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detailed(widget.p_id)),
        );
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Detailed(widget.p_id)),
      );
    }
  }

  Future<Uri> CreateDynamicLink() async {
    setState(() {
      // _createLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://poshaqin.page.link',
        link: Uri.parse(
            'https://poshaqin.page.link/Detailed?p_id=${widget.p_id}'),
        androidParameters: AndroidParameters(
          packageName: 'com.poshaq.customer',
          minimumVersion: 1,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "Poshaq Product",
            description: "The random description of the dynamic"));
    Uri url;
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    // var dynamicUrl = await parameters.buildUrl();
    url = shortDynamicLink.shortUrl;
    setState(() {
      // _createLink = false;
      _linkMessage = url.toString();
    });
    return url;
  }

  var responsed;
  String stocke, return_name;
  bool loding = false, getimg = false, desc = false;
  int clr = 0, sze, likes = 0, dislike = 0;
  bool allike = false;
  var colores, sizee, descr;
  String sel_color, sel_size, clr_code, sel_size_name;
  List<dynamic> imageList = List<dynamic>();
  List<String> sizes = new List<String>();
  bool data = false, wishbtn = false;
  Future<void> getProducts() async {
    try{
    print("Product Id:  " + widget.p_id);
    http.Response response = await http.post(API.fetch_detailed, body: {
      'authkey': API.key,
      'p_id': widget.p_id,
      'customer_id': customer_id,
    });
    print("dats is here:::");
    print(response.body);
    setState(() {
      responsed = json.decode(response.body);
      if (responsed['status'] == 2) {
        loding = true;
        data = false;
        var images = responsed['result'][0]['images'];
        if (customer_id != "0") {
          allike = responsed['result'][0]['product_liked'].toString() == "1"
              ? true
              : false;
        } else {
          allike = false;
        }
        likes =
            int.parse(responsed['result'][0]['upvote'].toString() ?? "0") ?? 0;
        if (responsed['result'][0]['colors'].length != 0) {
          colores = responsed['result'][0]['colors'];
          sel_color = colores[0]['color_id'];
          clr_code = colores[0]['color_code'];
          if (responsed['result'][0]['colors'][0]['sizes'].length != 0) {
            sizee = responsed['result'][0]['colors'][0]['sizes'];
            // sel_size = sizee[0]['product_size_id'];
            // sel_size_name = sizee[0]['size'];
            // stocke = sizee[0]['instock'].toString();

          } else {
            sizee = null;
          }
        } else {
          colores = null;
        }
        descr = responsed['result'][0]['prod_desc'];
        return_name = responsed['result'][0]['return_name'].toString();
        if (images.length != 0) {
          for (int i = 0; i < images.length; i++) {
            imageList.add(NetworkImage(
                responsed['result'][0]['images'][i]['img_url'].toString()));
          }
          setState(() {
            getimg = true;
          });
//            for(var i in image)print(image[0]);
        }
      } else {
        loding = true;
      }
    });
     } catch(e){
       setState(() {
         loding = true;
         data = true;
       });
       Fluttertoast.showToast(msg: "Error In Product Loading!",backgroundColor: Constants.PRIMARY_COLOR);
    }
  }

  onchange_color(int index) {
    setState(() {
      print(colores[index]['color_id']);
      sel_color = colores[index]['color_id'].toString();
      clr_code = colores[index]['color_code'].toString();
      sizee = responsed['result'][0]['colors'][index]['sizes'];
      sel_size = sizee[0]['product_size_id'].toString();
      stocke = sizee[0]['instock'].toString();
    });
  }

  upvote() async {
    setState(() {
      likes = likes + 1;
      allike = true;
    });
    http.Response response = await http.post(API.upvote, body: {
      'authkey': API.key,
      'customer_id': customer_id,
      'p_id': widget.p_id,
    });
    setState(() {
      print(response.body);
      var res = json.decode(response.body);
      if (res['status'] == 2) {
        // getProducts();
      } else {
        Fluttertoast.showToast(msg: "Error Occured");
        setState(() {
          likes = likes - 1;
          allike = false;
        });
      }
    });
  }

  dovote() async {
    setState(() {
      likes = likes - 1;
      allike = false;
    });
    http.Response response = await http.post(API.dovote, body: {
      'authkey': API.key,
      'customer_id': customer_id,
      'p_id': widget.p_id,
    });
    setState(() {
      print(response.body);
      var res = json.decode(response.body);
      if (res['status'] == 2) {
        // getProducts();
      } else {
        Fluttertoast.showToast(msg: "Error Occured");
        setState(() {
          likes = likes + 1;
          allike = true;
        });
      }
    });
  }
  var Custom_cart;
  String customer_id;
  bool login = false;
  getSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString("customer_id") ?? "0";
    login = prefs.getBool("login") ?? false;
    print("customer:" + customer_id);
    cart_data = prefs.getString("cart_data") ?? "0";
    cart_color = prefs.getString('cart_color') ?? "0";
    cart_size = prefs.getString('cart_size') ?? "0";
    cart_size_name = prefs.getString('cart_size_name') ?? "0";
    Custom_cart = prefs.getString('Custom_cart') ?? [];
    print(Custom_cart);
    if(Custom_cart.length!=0){
      Custom_cart = jsonDecode(Custom_cart);
    }
    getProducts();
  }
  getCustomCart()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Custom_cart = prefs.getString('Custom_cart') ?? [];
    });
    print(Custom_cart);
  }
  double heightAppBar = 450.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Detailed:  "+widget.p_id.toString());
    initialCheck();
    heightAppBar = 450;
    getSp();
  }

  void share() async{
    var url = await buildUrl(widget.p_id);
    print(url.toString());
    Share.share(url.toString(),subject: "Sharing Product Details");
  }

  Future<Uri> buildUrl(String p_id) async{
    DynamicLinkParameters parameter = DynamicLinkParameters(
        uriPrefix: "https://poshaqin.page.link",
        link: Uri.parse("http://poshaqin.page.link/product?p_id=$p_id"),
        androidParameters: AndroidParameters(
          packageName: "com.poshaq.customer",
          minimumVersion:0,
        ),
        iosParameters:  IosParameters(
          bundleId: 'com.poshaq.customer',
          minimumVersion: '0',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            description: "Please have a look for the "+responsed['result'][0]['name'].toString(),
            title: responsed['result'][0]['name'].toString(),
            imageUrl: Uri.parse(responsed['result'][0]['images'][0]['img_url'].toString())
        )
    );
    print(parameter.link.toString());
    var u = await parameter.buildShortLink();
    return u.shortUrl;
  }


  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 450.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          "Description :",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 30,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  child: Text(
                                    "Property",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // color: Colors.red,
                                ),
                                Container(
                                  child: Center(child: Text(":")),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Value",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.grey,
                          )),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: descr.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        child: Text(
                                          descr[index]['property'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // color: Colors.red,
                                      ),
                                      Container(
                                        child: Center(child: Text(":")),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            descr[index]['value'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget image_slider = Container(
      height: 400,
      child: getimg
          ? Carousel(
              boxFit: BoxFit.fill,
              images: imageList,
              autoplay: false,
              showIndicator: true,
              dotSize: 5.0,
              dotSpacing: 20.0,
              dotBgColor: Constants.ACCENT_COLOR,
              indicatorBgPadding: 0.0,
              dotColor: Constants.PRIMARY_COLOR,
            )
          : Container(
              height: 450,
              child: ProgressDailog().Progress(context),
            ),
    );
    return Scaffold(
      body: loding
          ? data
              ? Container(
                  child: Center(
                    child: RaisedButton(
                      color: Constants.PRIMARY_COLOR,
                      child: Text(
                        "Network Error Reload",
                        style: TextStyle(color: Constants.ACCENT_COLOR),
                      ),
                      onPressed: () {
                        setState(() {
                          loding = false;
                        });
                        getProducts();
                      },
                    ),
                  ),
                )
              : DefaultTabController(
                  length: 2,
                  initialIndex: 1,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: heightAppBar,
                          floating: true,
                          pinned: true,
                          snap: true,
                          backgroundColor: Constants.ACCENT_COLOR,
                          iconTheme: IconThemeData(
                            color: Colors.transparent,
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: Constants.PRIMARY_COLOR,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.redeem,
                                color: Constants.PRIMARY_COLOR,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyCart())).then((value) => login?print(""):getCustomCart());
                              },
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: image_slider,
                            ),
                          ),
                        )
                      ];
                    },
                    body: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 12,
                            child: Container(
                              color: Colors.white12,
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    responsed['result'][0]
                                                            ['name']
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                            Container(
                                                // child: IconButton(
                                                //   icon: Icon(Icons.share),
                                                //   onPressed: () async {
                                                //     // await initialCheck();
                                                //     await Share.share(
                                                //         _linkMessage);
                                                //   },
                                                // ),
                                                child: FutureBuilder<Uri>(
                                                    future: CreateDynamicLink(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        Uri uri = snapshot.data;

                                                        return IconButton(
                                                          icon:
                                                              Icon(Icons.share),
                                                          onPressed: () {
                                                              share();
                                                            },
                                                        );
                                                      } else {
                                                        return IconButton(
                                                          icon:
                                                              Icon(Icons.share),
                                                          onPressed: () {},
                                                        );
                                                      }
                                                    })),
                                          ],
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                sel_size!=null?stocke == "1"
                                                    ? "In Stock"
                                                    : "Out Stock":" ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
//                                width: MediaQuery.of(context).size.width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 5,
                                                ),
                                                child: Text(
                                                    "\u20B9" +
                                                        responsed['result'][0]
                                                                ['price']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                            Container(
//                                width: MediaQuery.of(context).size.width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 0.0,
                                                  right: 10,
                                                ),
                                                child: Text(
                                                    "\u20B9" +
                                                        responsed['result'][0]
                                                                ['mrp']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.grey)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(3.0),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 9.0),
                                                  child: Text("Color ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      )),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12.0),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              20,
                                                      height: 30,
                                                      child: colores != null
                                                          ? ListView.builder(
                                                              itemCount: colores
                                                                  .length,
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        clr =
                                                                            index;
                                                                        onchange_color(
                                                                            index);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: clr ==
                                                                                index
                                                                            ? Border.all(
                                                                                color: Constants.PRIMARY_COLOR,
                                                                                width: 2,
                                                                              )
                                                                            : Border.all(),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            22,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(int.parse("0xff" + colores[index]['color_code'].toString())),
                                                                          border: clr == index
                                                                              ? Border.all(
                                                                                  color: Constants.ACCENT_COLOR,
                                                                                  width: 1,
                                                                                )
                                                                              : Border.all(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                          : Text(
                                                              "No Colors to show!"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 9.0),
                                                  child: Text("Size ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      )),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 12.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      20,
                                                  height: 40,
                                                  child: sizee != null
                                                      ? ListView.builder(
                                                          itemCount:
                                                              sizee.length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(3.0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    sel_size = sizee[index]
                                                                            [
                                                                            'product_size_id']
                                                                        .toString();
                                                                    sel_size_name =
                                                                        sizee[index]['size']
                                                                            .toString();
                                                                    sze = index;
                                                                    stocke = sizee[index]
                                                                            [
                                                                            'instock']
                                                                        .toString();
                                                                    print(sel_size +
                                                                        sel_size_name);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 60,
                                                                  child: Center(
                                                                      child: Text(
                                                                          sizee[index]['size']
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Constants.PRIMARY_COLOR))),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        width: sze ==
                                                                                index
                                                                            ? 2
                                                                            : 0.5,
                                                                        color: sze ==
                                                                                index
                                                                            ? Colors.grey[500]
                                                                            : Colors.grey[200]),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : Text(
                                                          "No Sizes to show!"),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, bottom: 0),
                                            child: FlatButton(
                                              onPressed: () {
                                                Fluttertoast.showToast(
                                                    msg: "Shipping polocies");
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4.0),
                                                          child: Container(
                                                              width: 20,
                                                              child: Icon(
                                                                Icons
                                                                    .airport_shuttle,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                        ),
                                                        Expanded(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Container(
                                                              child: Text(
                                                            "Free standard shipping on order over 1000 And Estimeted to be delivered in 1 or 2 days",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      width: 20,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 15,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.2)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, bottom: 0),
                                            child: FlatButton(
                                              onPressed: () {
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.security,
                                                          size: 20,
                                                          color: Colors.green,
                                                        ),
                                                        Text(
                                                          return_name
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
//                                    color: Colors.red,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, bottom: 0),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageViewers("Size Chart", "https://www.saffronitsystems.com/dproject/index.php/product//fetch_file_img?img=size.jpg")));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Size Chart",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Icon(Icons.arrow_forward_ios),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.2)),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, right: 0, bottom: 0),
                                            child: Container(
                                              child: FlatButton(
                                                onPressed: () {
                                                  descr.length != 0
                                                      ? _modalBottomSheetMenu()
                                                      : Fluttertoast.showToast(
                                                          msg:
                                                              "No Description!!");
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("Description",
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    descr.length != 0
                                                        ? Text(
                                                            "...",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          )
                                                        : Text(
                                                            "No Description available",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.2)),
//                                    color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Padding(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   child: Text("Review ("+(likes).toString() +"):",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Like :",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            likes.toString(),
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //   children: [
                                                      //     Text("Dislike :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                      //     Text(dislike.toString(),style: TextStyle(fontSize: 16),)
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.thumb_up,
                                                            color: allike
                                                                ? Constants
                                                                    .PRIMARY_COLOR
                                                                : Colors.grey,
                                                          ),
                                                          onPressed: () {
                                                            if (login == true) {
                                                              allike
                                                                  ? dovote()
                                                                  : upvote();
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Login to Vote!",
                                                                  backgroundColor:
                                                                      Constants
                                                                          .PRIMARY_COLOR,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER);
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding: EdgeInsets.all(8),
                                                      //   child: IconButton(
                                                      //     icon: Icon(Icons.thumb_down),
                                                      //   ),
                                                      // ),
                                                    ],
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
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[200],
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: 50,
                                        child: IconButton(
                                          onPressed: () {
                                            if(sel_size!=null){
                                              add_wish_list();
                                              setState(() {
                                                wishbtn = true;
                                              });
                                            }else{
                                              Fluttertoast.showToast(msg: "Select Size First!");
                                            }
                                          },
                                          icon: Icon(
                                            wishbtn
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 50,
//                                height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.black,
                                      child: FlatButton(
//                                color:Theme.of(context).primaryColor,
                                        onPressed: () {
                                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCart()));
                                          setState(() {
                                            print(sel_size.toString());
                                            sel_size != null
                                                ? add_to_cart(
                                                    widget.p_id,
                                                    sel_size,
                                                    clr_code,
                                                    sel_size_name)
                                                : Fluttertoast.showToast(
                                                    msg:
                                                        "Select a Size First!");
                                            // loding = false;
                                          });
                                        },
                                        color: Colors.black,
                                        child: Text(
                                            adding ? "Adding.." : "Add to Bag",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
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
                )
          : ProgressDailog().Progress(context),
    );
  }

  // share(BuildContext context) {
  //   final RenderBox box = context.findRenderObject();
  //
  //   Share.share("dssd- fdf",
  //       subject: "dfdf",
  //       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  // }
  String cart_data = "0",
      cart_color = "0",
      cart_size = "0",
      cart_size_name = "0";
  addtoSP() async {
    print("Add TO SP");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Custom_cart", jsonEncode(Custom_cart));
    print(jsonDecode(prefs.getString("Custom_cart")));
    setState(() {
      adding = false;
    });
    Fluttertoast.showToast(msg: "Iteam Added to cart!!");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart())).then((value) => login?print(""):getCustomCart());
  }

  bool adding = false;
  offline_cart(String p_id, String size_id, String color, String size_name) {
    setState(() {
      var Custom_cart_data = {
        'p_id' : p_id.toString(),
        'color' : color.toString(),
        'size_id' : size_id.toString(),
        'size_name' : size_name.toString(),
      };
      print("Virtual Cart: ");
      print(Custom_cart);
      print("adding");
      Custom_cart.add(Custom_cart_data);
      print(Custom_cart);
      loding = true;
      addtoSP();
    });
  }
  bool exist = false;
  add_to_cart(
      String p_id, String size_id, String color, String size_name) async {
    setState(() {
      adding = true;
    });
    print(p_id + "  " + size_id + " " + size_name + " " + color);
    print(customer_id);
    if (customer_id == "0") {
      for(int i = 0 ; i < Custom_cart.length ; i++){
        print(i);
        print(Custom_cart[i]['p_id']);
        if(Custom_cart[i]['p_id']==p_id.toString()){
          if(Custom_cart[i]['size_id']==size_id.toString()){
            print("Iteam Already in Cart");
            setState(() {
              exist = true;
              adding = false;
            });
            Fluttertoast.showToast(msg: "Item Is Already In Cart!!");
          } else {
            print("Item not Exist");
            setState(() {
              exist = false;
            });
          }
        } else {
          print("Else Outer");
        }
      }
      if(!exist){
        offline_cart(p_id, size_id, color, size_name);
      }
    } else {
      print("adding data");
      http.Response response = await http.post(API.add_cart, body: {
        'authkey': API.key,
        'p_id': p_id,
        'customer_id': customer_id,
        'size_id': size_id,
      });
      print(response.body);
      setState(() {
        adding = false;
        loding = true;
        var resp = jsonDecode(response.body);
        if (resp['status'] == 2) {
          Fluttertoast.showToast(msg: resp['message'].toString());
          print("Added to customer cart: " + customer_id);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => MyCart()));
        } else {
          Fluttertoast.showToast(msg: resp['message'].toString());
        }
      });
    }
  }
  bool wishload = false;
  add_wish_list() async {
    if (login == false) {
      Fluttertoast.showToast(
          msg: "Login to add to Wishlist", gravity: ToastGravity.CENTER);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login(0)));
    } else {
      print("Size:" + sel_size);
      setState(() {
        wishload = true;
      });
      try {
        http.Response response = await http.post(API.add_wishlist, body: {
          'authkey': API.key,
          'customer_id': customer_id,
          'p_id': widget.p_id,
          'size_id': sel_size,
        });
        print(response.body);
        setState(() {
          var resposed = json.decode(responsed.body);
          Fluttertoast.showToast(msg: responsed['message']);
          if (responsed['status'] == 2) {
            wishbtn = true;
          } else {
            wishbtn = false;
          }
        });
      } catch (e) {
        // Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
      print("Add to Wishlist");
    }
  }
}
