import 'dart:convert';
import 'package:dproject/Constants.dart';
import 'package:dproject/FinalPage.dart';
import 'package:dproject/ProgressDailog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'PaymentScreen.dart';
class PaymentMode extends StatefulWidget {
  double total;
  bool cod;
  String name,address,mobile;
  PaymentMode(double this.total, bool this.cod,String this.name, String this.mobile,String this.address){
    print("Total: "+total.toString()+", COD: "+cod.toString());
    print(name);
    print(mobile);
    print(address);
  }

  @override
  _PaymentModeState createState() => _PaymentModeState();
}

class _PaymentModeState extends State<PaymentMode> {
  List ai ;
  int _value = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ai = widget.cod?['Paytm','COD']:['Paytm'];
    // ai = ['Paytm','COD'];
    getSP();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Payment Mode"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white10,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 200,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Select Payment Mode: ",style: TextStyle(fontSize: 18),),
                        Text("  "),
                        for (int i = 0; i < ai.length; i++)
                          ListTile(
                            title: Text(
                              ai[i].toString(),
                              style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 5 ? Colors.black38 : Colors.black),
                            ),
                            leading: Radio(
                              value: i,
                              groupValue: _value,
                              activeColor: Color(0xFF6200EE),
                              onChanged: (int value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  )   ,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Constants.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Constants.PRIMARY_COLOR,
                onPressed: (){
                  load?addOrderCod():Fluttertoast.showToast(msg: "Wait a minute");
                },
                child: load?Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Proceed",style: TextStyle(fontSize:20,color: Constants.ACCENT_COLOR),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios,color: Constants.ACCENT_COLOR),
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Processing...",style: TextStyle(fontSize:20,color: Constants.ACCENT_COLOR),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitCircle(
                        color: Constants.ACCENT_COLOR,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String customer_id;
  getSP()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString("customer_id")??"0";
    print("customer_id: "+customer_id);
  }
  bool load = true;
  addOrderCod()async{
    setState(() {
      load  = false;
    });
    if(_value==1){
      print("cod");
      _value = 1;
    }else if(_value ==0){
      _value = 2;
      print("Paytm");
    }
      http.Response response = await http.post(
        API.add_order,
        body: {
          'authkey' : API.key,
          'customer_id' : customer_id,
          // 'selling_price' : widget.total.toString(),
          'customer_name' : widget.name,
          'address' : widget.address,
          'mobile' : widget.mobile,
          'payment_mode' : _value.toString(),
        }
      );
      print(response.body);
      setState(() {
        load = true;
        var responsed = json.decode(response.body);
        if(responsed['status']==2){
          print("Done");
          var total = 1000;
          var order;
          setState(() {
            total = responsed['result']['amount'];
            order = responsed['result']['order'];
            if(total<999.0){
              total = total+ 65;
            }
            total = total+20;
          });
          if(_value == 1) {
            // Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) =>
                    FinalPage(responsed['order_id'].toString())));
          }
          else{
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> PaymentScreen(amount: total.toString(),order : order)));
          }
          }else{
          Fluttertoast.showToast(msg: responsed['message'],backgroundColor: Constants.PRIMARY_COLOR,textColor: Constants.ACCENT_COLOR);
        }
      });
  }
}
