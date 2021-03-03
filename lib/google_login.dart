import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'Dashboard.dart';
import 'ProgressDailog.dart';

class GoogleLogin extends StatefulWidget {
  String email, name, photo;
  GoogleLogin(String this.email, String this.name, String this.photo) {
    print(email + " " + name + " " + photo);
  }
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  String mobile;
  var Custom_cart;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
  }

  String token;
  getSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print("token:" + token);
    Custom_cart = prefs.getString('Custom_cart') ?? [];
    print(Custom_cart);
    if(Custom_cart.length!=0){
      Custom_cart = jsonDecode(Custom_cart);
    }
    print(Custom_cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Login"),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Authenticate Mobile Number",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red,
              child: Image.network(widget.photo),
            ),
          ),
          Text("Name: " + widget.name),
          Text(" "),
          Text("Email: " + widget.email),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              onChanged: (input) {
                mobile = "+91" + input;
              },
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Mobile",
                counterText: "",
                prefix: Text("+91"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: loding
                ? RaisedButton(
                    color: Constants.PRIMARY_COLOR,
                    child: Text(
                      "Send OTP ",
                      style: TextStyle(
                          color: Constants.ACCENT_COLOR, fontSize: 16),
                    ),
                    onPressed: () {
                      if (mobile != null) {
                        setState(() {
                          loding = false;
                        });
                        print("Button Pressed");
                        sendOTP(mobile, true);
                      } else {
                        Fluttertoast.showToast(
                          msg: "Insert Mobile number!",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        color: Constants.PRIMARY_COLOR,
                        child: Text(
                          "Wait a Moment",
                          style: TextStyle(
                              color: Constants.ACCENT_COLOR, fontSize: 16),
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Wait a moment");
                        },
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SpinKitRing(
                            color: Constants.PRIMARY_COLOR,
                            size: 40,
                            lineWidth: 5.0,
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

  String otp;
  bool loding = true, complete = true, resend = false, presed = false;
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
      print(responsed['messgae']);
      Fluttertoast.showToast(msg: responsed['message']);
      if (type)
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              // print("Opening OTP WIndow!!");
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
                    height: 150,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
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
                            "OTP has been sent to your number $mobile. Please enter it below..",
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
                                  // addlogin();
                                  setState(() {
                                    complete = true;
                                  });
                                  register_customer_google();
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
                                    sendOTP(mobile, false);
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
                padding: const EdgeInsets.only(top: 100.0),
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

  register_customer_google() async {
    setState(() {
      print("11111");
      loding = false;
      print(widget.name + "  " + widget.email + "  " + mobile + "  " + token);
    });
    http.Response response = await http.post(API.registergooglelogin, body: {
      'authkey': API.key,
      'email': widget.email,
      'mobile': mobile,
      'name': widget.name,
      'device_token': token,
    });
    print(" -----   ");
    print(response.body);
    print(" -----   ");
    if (response.statusCode == 200) {
      setState(() {
        loding = true;
        var res = json.decode(response.body);
        if (res['status'] == 2) {
          addlogin(res['result']['customer_id'].toString());
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: res['message'].toString());
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Network Error!1");
      setState(() {
        loding = true;
      });
    }
  }

  addlogin(id) async {
    setState(() {
      addStringToSF("name", widget.name.toString());
      addStringToSF("email", widget.email.toString());
      addStringToSF("profile_img", widget.photo.toString());
      addStringToSF("mobile", mobile.toString());
      addStringToSF("customer_id", id.toString());
      addlogin2(id.toString());
    });
  }

  addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  addlogin2(String customer_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true);
    updateCart(customer_id);
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
      loding = true;
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
    setState(() {
      loding = true;
    });
    // if (widget.k == 1) {
    //   Navigator.pop(context);
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => MyCart()));
    // } else if (widget.k == 2) {
    //   Navigator.pop(context);
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => WishList()));
    // } else
    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
    Navigator.popUntil(context, ModalRoute.withName('/Dashboard'));
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Dashboard()));
  }
}
