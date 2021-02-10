import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dproject/Constants.dart';
import 'package:dproject/login.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';

void main() {
  runApp(MaterialApp(
    title: Constants.APP_NAME,
    home: Splash(),
    theme: ThemeData(
      primaryColor: Constants.PRIMARY_COLOR,
      accentColor: Constants.ACCENT_COLOR,
      backgroundColor: Constants.BACKGROUND_COLOR
    ),
    routes: <String,WidgetBuilder>{
      "/Login":(BuildContext context)=> Login(0),
      "/Dashboard":(BuildContext context)=> Dashboard(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCloudMessaging_Listeners();
    //
  }
  tokens(String token)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    print(token);
    Timer(Duration(milliseconds: 1000),()=>getSP());
}
  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((tokeen){
      setState(() {
        token = tokeen;
        // print(tokeen);
        tokens(token);
      });
    });  _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("On Launch");
        print('on launch $message');
      },
    );
  }void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }
  Future initDynamicLinks() async {
    PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    Uri deepLink = data?.link;
    print("spalsh : "+deepLink.toString());
    if (deepLink != null) {
      print("path:- " + deepLink.path);
      if (deepLink.path == "/product") {
        var param = deepLink.queryParameters['p_id'];
        print("param 1 : "+param);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          Uri deepLink = dynamicLink?.link;
          print("on success: "+deepLink.toString());
          if (deepLink != null) {
            print("path:- " + deepLink.path);
            print(deepLink.queryParameters.toString());
            if (deepLink.path == "/product") {
              var param = deepLink.queryParameters['p_id'].toString();
              print(param);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
            }
            else
              print("no");
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
//    getSP();
  }
  getSP() {
    Navigator.pushReplacementNamed(context, "/Dashboard");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset("images/poshaq bg-09-min.jpg",fit: BoxFit.fill,),
          ),
          Center(
            child: Image.asset("images/poshaq logo-01.png",width: 200,height: 200,),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Text("MADE IN INDIA",style: TextStyle(color: Constants.ACCENT_COLOR,fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}
