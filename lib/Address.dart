import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'CheckOut.dart';
import 'Constants.dart';
import 'NewAddress.dart';
import 'ProgressDailog.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool getaddr= false, isaddr = false;
  String name,customer_id,email,mobile,_result = "0",nametosend,address,pincode,add_id;
  var _radioValue=0,responsed;
  getStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString("name");
//      email=prefs.getString("email");
      mobile=prefs.getString("mobile");
      customer_id=prefs.getString("customer_id");
      getaddress();
    });
  }
  getaddress()async{
    final http.Response response = await http.post(
        API.getaddress,
        headers: <String, String>{
          'Content_Type': 'application/json; charset=UTF-8'
        },
        body: {
          'authkey' : API.key,
          'customer_id' : customer_id,
        });
   print(response.body);
    if(response.statusCode==200){
      responsed = json.decode(response.body);
      if(responsed['status']==2){
        setState(() {
          dltadd = false;
          getaddr = true;
          isaddr= true;
          add_id = responsed['result'][0]['address_id'].toString();
          nametosend=responsed['result'][0]['name'].toString();
          mobile  = responsed['result'][0]['mobile'].toString();
          address = responsed['result'][0]['address']+responsed['result'][0]['city'].toString();
          pincode =responsed['result'][0]['pincode'].toString();
          print(address);
        });
      }else{
        setState(() {
          getaddr = true;
          isaddr = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NewAddress(1)));
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Address"),
      ),
      body: getaddr?isaddr?Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-ScreenUtil().setHeight(170),
            child: ListView(
              children: <Widget>[
                Card(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NewAddress(1)));
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      child: Padding(
                        padding:  EdgeInsets.all(ScreenUtil().setSp(8.0)),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add,color: Theme.of(context).primaryColor,),
                            Text("   Add Address",style: TextStyle(fontSize: ScreenUtil().setSp(16),color: Theme.of(context).primaryColor),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-ScreenUtil().setHeight(200),
                  child: ListView.builder(
                      itemCount: responsed["result"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return  Card(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            new Radio(
                                              value: index,
                                              focusColor: Colors.green,
                                              activeColor: Constants.PRIMARY_COLOR,
                                              groupValue: _radioValue,
                                              onChanged:(value) {
                                                setState(() {
                                                  _radioValue = value;
                                                  _result = "$value";
                                                  add_id = responsed['result'][index]['address_id'].toString();
                                                  nametosend = responsed['result'][index]['name'].toString();
                                                  pincode = responsed['result'][index]['pincode'].toString();
                                                  mobile = responsed['result'][index]['mobile'].toString();
                                                  address = responsed['result'][index]['address'].toString()+", "+responsed['result'][index]['city'].toString();
                                                });
                                                print(address);
                                              },
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(responsed['result'][index]['name']!=null?responsed['result'][index]['name']:"$name",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: ScreenUtil().setSp(16))),
//                                            Text(responsed['result'][index]['name']!=null?"hello":"$name",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                        ),
                                        Container(
                                          decoration: new BoxDecoration(
                                            border: Border.all(color: Theme.of(context).accentColor),
                                          ),
                                          child: Text("HOME",style: TextStyle(fontSize: ScreenUtil().setSp(8))),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top:ScreenUtil().setHeight(1),left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(12)),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Text(responsed['result'][index]['address'].toString(),style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Text(responsed['result'][index]['city']+", "+responsed['result'][index]['pincode'],style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top:ScreenUtil().setHeight(4),left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(12),bottom: ScreenUtil().setWidth(12)),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(responsed['result'][index]['mobile']!=null?responsed['result'][index]['mobile']:"$mobile",style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              responsed['result'].length!=1?Positioned(
                                right: 5,top: 5,
                                child: Container(
                                  width: ScreenUtil().setWidth(70),
                                  height: ScreenUtil().setHeight(30),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).accentColor)
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: (){
                                        dltadd==false?showDialog(context:context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text("Confirm Delete Address: "),
                                            actions: [
                                              RaisedButton(
                                                child: Text("Yes"),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  deleteAddress(responsed['result'][index]['address_id']);
                                                },
                                              ),
                                              RaisedButton(
                                                child: Text("No"),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  // deleteAddress(responsed['result'][index]['address_id']);
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                        ):Fluttertoast.showToast(msg: "Wait a Minute!!");
                                      },
                                      color: Colors.white,
                                      icon:Icon(dltadd?Icons.linear_scale:Icons.delete,color: Colors.red,),
                                    ),
                                  ),
                                ),
                              ):Center(),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(62),
            width: MediaQuery.of(context).size.width-40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: MaterialButton(
              onPressed: (){
                String addressed;
                print(nametosend);
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckOut(nametosend,address,pincode,add_id,mobile)));
              },
              child: Text("Select Address",style: TextStyle(fontSize:ScreenUtil().setSp(20),color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ],
      ):Center(child: Text("No address Found Please add Address!!"),):ProgressDailog().Progress(context)
    );
  }
  bool dltadd = false;
  deleteAddress(String id)async{
    print(id);
    setState(() {
      dltadd = true;
    });
    try{
      http.Response response = await http.post(
        API.deleteaddress,
        body: {
          'authkey' : API.key,
          'address_id' : id,
        }
      );
      print(response.body);
      setState(() {
        dltadd = false;
        var responsed = json.decode(response.body);
        print(responsed);
        Fluttertoast.showToast(msg: responsed['message'].toString());
        if(responsed['status']==2){
          getaddress();
        }else{
          print("error");
        }
      });
    }catch(e){
      setState(() {
        print(e.toString());
        dltadd = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
