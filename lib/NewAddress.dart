import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Address.dart';
import 'CheckOut.dart';
import 'Constants.dart';

class NewAddress extends StatefulWidget {
  int k;
  NewAddress(int this.k);
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  String flat_no,area=" ",city,pincode,mobile,customer_id,name;
  bool add = false;
  bool _validate = false;
  bool _validate2 = false;
  bool _validate3 = false;
  bool _validate4 = false;
  bool _validate5 = false;
  bool _validate6 = false;
  final _text = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();
  final _text4 = TextEditingController();
  final _text5 = TextEditingController();
  final _text6 = TextEditingController();
  getStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString('customer_id');
  print(customer_id);
  }
  addaddress(String name,String flat_no,String area,String mobile,String city,String pincode)async{
    setState(() {
      add = true;
    });
    print("Adding Address");
    final http.Response response = await http.post(
        API.addaddress,
        headers: <String, String>{
          'Content_Type': 'application/json; charset=UTF-8'
        },
        body: {
          'authkey' : API.key,
          'customer_id' : customer_id,
          'name' : name,
          'address' : flat_no+", "+area,
          'pincode': pincode,
          'city' : city,
          'mobile': mobile,
        });
    print(response.body);
    if(response.statusCode==200){
      var responsed = json.decode(response.body);
      setState(() {
        add = false;
        if(responsed['status']==2){
          Fluttertoast.showToast(msg: "Address Added Succesfully");
          if(widget.k ==0){
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckOut(name,flat_no+", "+area+", "+city,pincode,responsed['address_id'].toString(),mobile)));
          }else{
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Address()));
          }
        }else{
          Fluttertoast.showToast(msg: "Error Occures try again!!");
        }
      });
    }else{
      Fluttertoast.showToast(msg: "Network Error!!");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringToSF();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.init(context, width: 392, height: 850, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Address"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(12)),
            child: Container(
              height: ScreenUtil().setHeight(70),
              //  width: 100*width,
              child: new TextFormField(
                controller: _text,
                style: TextStyle(color: Constants.PRIMARY_COLOR),
                decoration: new InputDecoration(
                  labelText: "Name",
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Constants.PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                  ),
                  focusedBorder : new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Constants.PRIMARY_COLOR, width: 2.0,),
                  ),
                ),
                onChanged: (input){
                  setState(() {
                    name = input;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(12)),
            child: Container(
              height: ScreenUtil().setHeight(70),
              //  width: 100*width,
              child: new TextFormField(
                controller: _text2,
                style: TextStyle(color: Constants.PRIMARY_COLOR),
                decoration: new InputDecoration(
                  errorText: _validate2 ? 'Value Can\'t Be Empty' : null,
                  labelText: "Address Line 1",
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Constants.PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Constants.PRIMARY_COLOR,
                  ),
                  focusedBorder : new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Constants.PRIMARY_COLOR, width: 2.0,),
                  ),
                ),
                onChanged: (input){
                  setState(() {
                    flat_no = input;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),top: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(12)),
            child: Container(
              height: ScreenUtil().setHeight(70),
              //  width: 100*width,
              child: new TextFormField(
                controller: _text3,
                style: TextStyle(color: Color(0xff5c8c3c)),
                decoration: new InputDecoration(
                  labelText: "Address Line 2",
//                  errorText: _validate3 ? 'Value Can\'t Be Empty' : null,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Constants.PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Constants.PRIMARY_COLOR,
                  ),
                  focusedBorder : new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Constants.PRIMARY_COLOR, width: 2.0,),
                  ),
                ),
                onChanged: (input){
                  setState(() {
                    area= " "+input;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),top: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(12)),
            child: Container(
              height: ScreenUtil().setHeight(70),
              //  width: 100*width,
              child: new TextFormField(
                controller: _text4,
                style: TextStyle(color: Color(0xff5c8c3c)),
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: new InputDecoration(
                  counterText: '',
                  prefix: Text("+91"),
                  labelText: "Mobile",
                  errorText: _validate4 ? 'Value Can\'t Be Empty' : null,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Constants.PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Constants.PRIMARY_COLOR,
                  ),
                  focusedBorder : new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Constants.PRIMARY_COLOR, width: 2.0,),
                  ),
                ),
                onChanged: (input){
                  setState(() {
                    mobile="+91"+input;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),top: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(12)),
            child: Container(
              height: ScreenUtil().setHeight(70),
              //  width: 100*width,
              child: new TextFormField(
                controller: _text5,
                style: TextStyle(color: Color(0xff5c8c3c)),
                decoration: new InputDecoration(
                  labelText: "City",
                  errorText: _validate5 ? 'Value Can\'t Be Empty' : null,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Constants.PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Constants.PRIMARY_COLOR,
                  ),
                  focusedBorder : new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Constants.PRIMARY_COLOR, width: 2.0,),
                  ),
                ),
                onChanged: (input){
                  setState(() {
                    city=input;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12),top: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(12)),
            child: Container(
              height: ScreenUtil().setHeight(70),
              //  width: 100*width,
              child: new TextFormField(
                controller: _text6,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Color(0xff5c8c3c)),
                maxLength: 6,
                decoration: new InputDecoration(
                  counterText: '',
                  labelText: "PIN Code",
                  errorText: _validate6 ? 'Value Can\'t Be Empty' : null,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Constants.PRIMARY_COLOR,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Constants.PRIMARY_COLOR,
                  ),
                  focusedBorder : new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: Constants.PRIMARY_COLOR, width: 2.0,),
                  ),
                ),
                onChanged: (input){
                  setState(() {
                    pincode = input;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(12),right: ScreenUtil().setWidth(12)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(60),
              child: add?RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                onPressed: (){
                  Fluttertoast.showToast(msg: "Wait a moment!!");
                },
                elevation: 3,
                child: Text("Adding ...",style: TextStyle(color: Colors.white,fontSize:  ScreenUtil().setSp(20)),),
              ):RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                onPressed: (){
                  setState(() {
                    _text.text.isEmpty ? _validate = true : _validate = false;
                    _text2.text.isEmpty ? _validate2 = true : _validate2 = false;
//                    _text3.text.isEmpty ? _validate3 = true : _validate3 = false;
                    _text4.text.isEmpty ? _validate4 = true : _validate4 = false;
                    _text5.text.isEmpty ? _validate5 = true : _validate5 = false;
                    _text6.text.isEmpty ? _validate6 = true : _validate6 = false;
                  });
                  print(flat_no+","+area+" "+mobile+"  "+city+" "+pincode);
                  if(_text6.text.length == 6){
                    if(_text4.text.length == 10){
                      addaddress(name,flat_no,area,mobile,city,pincode);
                    }else{
                      Fluttertoast.showToast(msg: "Mobile No is not correct!");
                    }
                  }else{
                    Fluttertoast.showToast(msg: "PinCode is not correct!");
                  }
                },
                elevation: 3,
                child: Text("Add",style: TextStyle(color: Colors.white,fontSize:  ScreenUtil().setSp(20)),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
