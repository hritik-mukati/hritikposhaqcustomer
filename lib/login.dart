import 'dart:convert';
import 'package:dproject/Dashboard.dart';
import 'package:dproject/WishList.dart';
import 'package:dproject/google_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dproject/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'MyCart.dart';
import 'ProgressDailog.dart';

class Login extends StatefulWidget {
  int k;
  Login(int this.k);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var lmail, lpass, rpassword, rpassword1;
  String gender = "Gender";
  var Custom_cart;
  @override
  void initState() {
    print(widget.k.toString());
    // TODO: implement initState
    super.initState();
    getSP();
    lmail = TextEditingController();
    lpass = TextEditingController();
    rpassword = TextEditingController();
    rpassword1 = TextEditingController();
    checklogin();
  }

  String token;
  getSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print("token: " + token);
    Custom_cart = prefs.getString('Custom_cart') ?? [];
    print(Custom_cart);
    if(Custom_cart.length!=0){
      Custom_cart = jsonDecode(Custom_cart);
    }
    print(Custom_cart);
  }

  checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login = prefs.getBool("login") ?? false;
    if (login == true) {
      Fluttertoast.showToast(msg: "Already Logged in!");
      Navigator.of(context).pop();
    } else {
      _logout_google();
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", false);
  }

  bool _sobscureText = true;
  bool _lobscureText = true;
  void _stoggle() {
    setState(() {
      _sobscureText = !_sobscureText;
    });
  }

  void _ltoggle() {
    setState(() {
      _lobscureText = !_lobscureText;
    });
  }

  //login api calls
  bool load = false;
  var email = "";
  var password = "";
  bool _loggedin = false;
  void checkLogin(String email, String pass) async {
    print("Login");
    if (email.isEmpty || pass.isEmpty) {
      Fluttertoast.showToast(msg: "Empty Fields");
      setState(() {
        load = false;
      });
    } else {
      setState(() {
        load = true;
      });
      print(email + pass);
      final http.Response response =
          await http.post(API.login, headers: <String, String>{
        'Content_Type': 'application/json; charset=UTF-8'
      }, body: {
        'authkey': API.key,
        'email': email,
        'password': pass,
        'device_token': token,
      });
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responsed = json.decode(response.body);
        print(responsed);
        if (responsed["status"] == 2) {
          setState(() {
            addStringToSF("name", responsed["result"][0]["name"]);
            addStringToSF("email", responsed["result"][0]["email"]);
            addStringToSF("customer_id",
                responsed["result"][0]["customer_id"].toString());
            addStringToSF("mobile", responsed["result"][0]["mobile"]);
            addlogin(responsed["result"][0]["customer_id"].toString());
          });
          Fluttertoast.showToast(msg: responsed["message"]);
        } else {
          setState(() {
            load = false;
          });
          Fluttertoast.showToast(
              msg: responsed["message"],
              backgroundColor: Colors.red,
              textColor: Colors.white);
        }
      } else {
        setState(() {
          load = false;
        });
        Fluttertoast.showToast(
            msg: "Network Error!!",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    }
  }

  addStringToSF(String name, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  addlogin(String customer_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true);
    updateCart(customer_id);
  }

  final datecontroller = TextEditingController();
  DateTime selectedDate = DateTime(1990, 1);
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        datecontroller.text = selectedDate.toString().substring(0, 10);
      });
  }

  String rname, rmobile, remail, rpass, rconpass;
  String otp;
  bool loding = true, complete = true, resend = false, presed = false;

  void check() async {
    setState(() {
      loding = false;
    });
    http.Response response = await http.post(API.check, body: {
      'authkey': API.key,
      'email': remail,
      'mobile': rmobile,
    });
    print(response.body);
    if (response.statusCode == 200) {
      var responsed = json.decode(response.body);
      if (responsed['status'] == 2) {
        sendOTP(rmobile, true);
      } else {
        setState(() {
          loding = true;
        });
        Fluttertoast.showToast(
            msg: responsed['message'].toString(),
            backgroundColor: Constants.PRIMARY_COLOR);
      }
    } else {
      setState(() {
        loding = true;
        Fluttertoast.showToast(
            msg: "Netowrk Error!", backgroundColor: Constants.PRIMARY_COLOR);
      });
    }
  }

  void sendOTP(String mobile, bool type) async {
    print("sending otp");
    final http.Response response =
        await http.post(API.snedOTP, headers: <String, String>{
      'Content_Type': 'application/json; charset=UTF-8'
    }, body: {
      'mobile': mobile,
      'authkey': API.key,
    });
    print(response.body);
    var responsed = json.decode(response.body);
    if (responsed['status'] == 2) {
      otp = responsed['otp'].toString().trim();
      String credentials = "username:password";
      Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
      otp = stringToBase64Url.decode(otp);
      print(otp);
      setState(() {
        loding = true;
      });
      Fluttertoast.showToast(msg: responsed['message']);
      if (type)
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              print("otp called" + complete.toString());
              return OTPwindowOTP();
            });
    } else {
      setState(() {
        loding = true;
      });
      Fluttertoast.showToast(msg: "Error : Please Try again in some time!!");
    }
  }

  Widget OTPwindowOTP() {
    return complete
        ? Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 250,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 60, left: 10, right: 10),
                          child: Text(
                            "Verify Mobile Number",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 30, right: 30),
                          child: Container(
                              //                        width:MediaQuery.of(context).size.width-10,
                              child: Center(
                                  child: Text(
                            "OTP has been sent to your number $rmobile. Please enter it below..",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ))),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 30, left: 10, right: 10),
                          child: OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldWidth: 50,
                            fieldStyle: FieldStyle.underline,
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            onCompleted: (pin) async {
                              setState(() {
                                complete = false;
                              });
                              try {
                                print("Completed: " + pin);
                                final code = pin;
                                if (code == otp) {
                                  Fluttertoast.showToast(
                                      msg: "Registering User..");
                                  signup(rname, remail, rmobile, rpass, gender,
                                      datecontroller.text);
                                } else {
                                  print("Invalid OTP");
                                  setState(() {
                                    complete = true;
                                  });
                                  Fluttertoast.showToast(msg: "Invalid OTP!!");
                                }
                              } catch (e) {
                                Fluttertoast.showToast(msg: "Invalid Code");
                              }
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: RaisedButton(
                                  child: Text("Resend OTP"),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    setState(() {
                                      resend = true;
                                      loding = false;
                                    });
                                    sendOTP(rmobile, false);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: RaisedButton(
                                  child: Text(
                                    "Change Number",
                                  ),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    setState(() {
                                      resend = true;
                                      loding = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                    height: 100,
                    child: Center(
                        child: CircleAvatar(
                            radius: 35,
                            child: Icon(
                              Icons.chat,
                              size: 45,
                            )))),
              ),
            ],
          )
        : Container(
            child: ProgressDailog().Progress(context),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Text(Constants.APP_NAME.toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 28))),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                          child: DefaultTabController(
                            length: 2,
                            child: Scaffold(
                              backgroundColor: Theme.of(context).accentColor,
                              appBar: TabBar(
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    insets:
                                        EdgeInsets.fromLTRB(60, 10, 60, 10)),
                                tabs: <Widget>[
                                  Tab(
                                    child: Text(
                                      "LOG IN",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                              body: TabBarView(
                                children: <Widget>[
                                  load
                                      ? Container(
                                          color: Constants.ACCENT_COLOR,
                                          child: ProgressDailog()
                                              .Progress(context),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextField(
                                                controller: lmail,
                                                decoration: InputDecoration(
                                                    labelText: "Email"),
                                              ),
                                              TextFormField(
                                                controller: lpass,
                                                obscureText: _lobscureText,
                                                decoration: InputDecoration(
                                                    labelText: "Password",
                                                    suffixIcon: IconButton(
                                                        onPressed: _ltoggle,
                                                        icon: Icon(_lobscureText
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off))),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: FlatButton(
                                                    textColor: Colors.white,
                                                    child: Text(
                                                      "LOGIN",
                                                      style: TextStyle(
                                                          fontSize: 17.0),
                                                    ),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    onPressed: () {
                                                      print("button");
                                                      print(lpass.text);
                                                      checkLogin(lmail.text,
                                                          lpass.text);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  loding
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView(
                                            children: <Widget>[
                                              TextFormField(
                                                initialValue: rname,
                                                decoration: InputDecoration(
                                                    labelText: "Name"),
                                                onChanged: (input) {
                                                  rname = input;
                                                },
                                              ),
                                              TextFormField(
                                                maxLength: 10,
                                                initialValue: rmobile != null
                                                    ? rmobile.substring(3)
                                                    : "",
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    counterText: "",
                                                    prefix: Text("+91"),
                                                    labelText: "Mobile"),
                                                onChanged: (input) {
                                                  rmobile = "+91" + input;
                                                },
                                              ),
                                              TextFormField(
                                                initialValue: remail,
                                                decoration: InputDecoration(
                                                    labelText: "Email"),
                                                onChanged: (input) {
                                                  remail = input;
                                                },
                                              ),
                                              TextFormField(
                                                controller: datecontroller,
                                                decoration: new InputDecoration(
                                                  labelText: "Date Of Birth",
                                                ),
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  _selectDate(context);
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    new DropdownButton<String>(
                                                  items: <String>[
                                                    'Gender',
                                                    'Male',
                                                    'Female'
                                                  ].map((String value) {
                                                    return new DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: new Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (gen) {
                                                    setState(() {
                                                      print(gen);
                                                      gender = gen;
                                                    });
                                                  },
                                                  value: gender,
                                                ),
                                              ),
                                              TextFormField(
                                                controller: rpassword1,
                                                obscureText: _sobscureText,
                                                decoration: InputDecoration(
                                                    labelText: "Password",
                                                    suffixIcon: IconButton(
                                                        onPressed: _stoggle,
                                                        icon: Icon(_sobscureText
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off))),
                                                validator: (val) =>
                                                    val.length < 6
                                                        ? 'Password too short.'
                                                        : null,
                                                onSaved: (val) => rpass = val,
                                                onChanged: (val) {
                                                  rpass = val;
                                                },
                                              ),
                                              TextFormField(
                                                controller: rpassword,
                                                obscureText: _sobscureText,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Confirm Password",
                                                    suffixIcon: IconButton(
                                                        onPressed: _stoggle,
                                                        icon: Icon(_sobscureText
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off))),
                                                validator: (val) =>
                                                    val.length < 6
                                                        ? 'Password too short.'
                                                        : null,
                                                onSaved: (val) =>
                                                    rconpass = val,
                                                onChanged: (val) {
                                                  rconpass = val;
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: FlatButton(
                                                    textColor: Colors.white,
                                                    child: Text(
                                                      "SIGN UP",
                                                      style: TextStyle(
                                                          fontSize: 17.0),
                                                    ),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    onPressed: () {
                                                      if (rpass == rconpass) {
                                                        print(rname +
                                                            " " +
                                                            remail +
                                                            " " +
                                                            rmobile +
                                                            " " +
                                                            datecontroller
                                                                .text +
                                                            " " +
                                                            gender +
                                                            " " +
                                                            rpass);
                                                        if (rname != null &&
                                                            remail != null &&
                                                            rmobile != null &&
                                                            datecontroller
                                                                    .text !=
                                                                null &&
                                                            gender !=
                                                                "Gender" &&
                                                            rpass != null) {
                                                          print("calling");
                                                          if (rpass.length >
                                                              5) {
                                                            check();
                                                          } else {
                                                            print("pass short");
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Password should be greater than 6 character!",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white);
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "All Fields Are mendetory!!",
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white);
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Password Does't Match",
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: EdgeInsets.all(10),
                                              //   child:Text("\u20B9300 OFF Your First Order Over \u20B92000",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 14),),
                                              // ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          color: Constants.ACCENT_COLOR,
                                          child: ProgressDailog()
                                              .Progress(context),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 1.0,
                              width: 30.0,
                              color: Colors.grey,
                            ),
                          ),
                          "Or Join With".TextWithColor(color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 1.0,
                              width: 30.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: () {
                            _login_google();
                          },
                          child: Container(
                              width: 35,
                              height: 35,
                              child: Center(
                                  child:
                                      Image.asset("images/google_logo.png"))),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )),
        ],
      ),
    );
  }

  signup(String name, String email, String mobile, String pass, String gender, String dob) async {
    print(name + email + mobile + pass + gender + dob);
    setState(() {
      loding = false;
    });
    http.Response response = await http.post(API.register, body: {
      'authkey': API.key,
      'email': email,
      'mobile': mobile,
      'name': name,
      'password': pass,
      'gender': gender,
      'dob': dob,
      'device_token': token,
    });
    print(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loding = true;
      var res = json.decode(response.body);
      if (res['status'] == 2) {
        prefs.setBool("login", true);
        prefs.setString("email", res['result']['email']);
        prefs.setString("mobile", res['result']['mobile']);
        prefs.setString("name", res['result']['name']);
        prefs.setString("customer_id", res['result']['customer_id'].toString());
        // Navigator.popUntil(context, (route) => false);
        Navigator.of(context).popUntil((route) => route.isFirst);
        updateCart(res['result']['customer_id'].toString());
        // Navigator.pushReplacement(
            // context, MaterialPageRoute(builder: (context) => Dashboard()));
        // prefs.setString("", value)
      } else {
        Fluttertoast.showToast(msg: "Error Occured!!");
      }
    });
  }

  // google login data..
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  _login_google() async {
    print("login google");
    try {
      print('Inside try block');
      await _googleSignIn.signIn();
      Fluttertoast.showToast(
          backgroundColor: Colors.black,
          msg: "Wait A Second!",
          fontSize: 18,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
      setState(() {
        print(_googleSignIn.currentUser.email);
        print(_googleSignIn.currentUser.displayName);
        print(_googleSignIn.currentUser.id);
        checklogingoogle(
            _googleSignIn.currentUser.email,
            _googleSignIn.currentUser.displayName,
            _googleSignIn.currentUser.photoUrl);
      });
    } catch (e) {
      print('catch block');
      print(e.toString());
    }
  }

  checklogingoogle(String email, String name, String photo) async {
    print('chckLogin goole');
    setState(() {
      load = true;
      print("1111");
      print(token);
    });
    http.Response response = await http.post(API.checkgooglelogin, body: {
      'authkey': API.key,
      'email': email,
      'device_token': token,
    });
    print(response.body);
    setState(() {
      var responsed = json.decode(response.body);
      if (responsed['status'] == 1) {
        print("1");
        setState(() {
          load = false;
        });
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoogleLogin(email, name, photo)))
            .then((value) => _logout_google());
      } else if (responsed['status'] == 2) {
        print("2");
        print("Already defined");
        load = false;
        addlogingoogle(
            email,
            name,
            photo,
            responsed['result'][0]['mobile'].toString(),
            responsed['result'][0]['customer_id'].toString());
      } else {
        print("3");
        _logout_google();
        setState(() {
          load = false;
        });
      }
    });
  }

  addlogingoogle(String email, String name, String photo, String mobile, String id) async {
    setState(() {
      addStringToSF("name", name.toString());
      addStringToSF("email", email.toString());
      addStringToSF("profile_img", photo.toString());
      addStringToSF("mobile", mobile.toString());
      addStringToSF("customer_id", id.toString());
      addlogin2(id.toString());
    });
  }

  addlogin2(String customer_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true);
    updateCart(customer_id);
    // if (widget.k == 1) {
    //   Navigator.pop(context);
    //   // Navigator.pushReplacement(
    //   //     context, MaterialPageRoute(builder: (context) => MyCart()));
    // } else if (widget.k == 2) {
    //   Navigator.pop(context);
    //   // Navigator.pushReplacement(
    //   //     context, MaterialPageRoute(builder: (context) => WishList()));
    // } else
    //   Navigator.pop(context);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

  _logout_google() {
    print("Google logout");
    _googleSignIn.signOut();
  }

  updateCart(String customer_id) async{
    print("Adding to Cart"+ customer_id);
    bool test = Custom_cart.length>0?true:false;
    if(test){
      print("local cart: "+Custom_cart.length.toString());
      addItemToCart(customer_id);
    }else{
      deleteSp();
    }
  }
  addItemToCart(String customer_id)async{
    print("in add item to cart");
    var arr = List<Map>();
    for(int i = 0;i<Custom_cart.length;i++){
      Map m = {
        "p_id":Custom_cart[i]['p_id'],
        "size_id":Custom_cart[i]['size_id']
      };
      arr.add(m);
      print(arr);
      print("adding item to cart");
    }
    var body = json.encode({
      'authkey' : API.key,
      'customer_id' : customer_id,
      'cart' : arr,
    });
    http.Response response = await http.post(
      API.add_cart_login,
      headers: <String, String>{
        'Content_Type': 'application/json; charset=UTF-8'
      },
      body: body,
    );
    print(response.body);
    setState(() {
        load = false;
      var res = json.decode(response.body);
      if(res['status']==2){
        print("Data Added Succesfully");
        deleteSp();
      }else if(res['status']==1){
        deleteSp();
      }
      else{
        Fluttertoast.showToast(msg: "Error in loading!!",backgroundColor: Constants.PRIMARY_COLOR);
      }
    });
  }
  deleteSp()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("Custom_cart");
    print("Here");
    // if (widget.k == 1) {
    //   Navigator.pop(context);
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => MyCart()));
    // } else if (widget.k == 2) {
    //   Navigator.pop(context);
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => WishList()));
    // } else
      Navigator.of(context).pop();
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Dashboard()));
  }
}
