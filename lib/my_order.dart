import 'dart:convert';
import 'package:dproject/PaymentScreen.dart';
import 'package:dproject/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Constants.dart';
import 'Line.dart';
import 'ProgressDailog.dart';

class MyOrder extends StatefulWidget {
  String title;
  String type;

  MyOrder(String this.title, String this.type);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  bool load = true,data = true,login = false;
  bool error = true;
  String customer_id;
  _showModal(var context,var id){
    showModalBottomSheet(context: context, isScrollControlled: true,builder:(context){
      return MainBottomSheet(id.toString());
    });
  }
  var listpending;
  getdata(String id)async{
    print("In get Orders");
    setState(() {
      error = true;
      load = false;
      print("got data");
      print(widget.type);
      listpending = null;
    });
    try{
      http.Response response = await http.post(
        API.fetchmyorders,
        body: {
          'authkey' : API.key,
          'customer_id' : id,
          widget.type!="0"?'status_id':"null" : widget.type!="0"?widget.type.toString():"0",
        }
      );
      print(response.body);
      setState(() {
       if(response.statusCode==200){
         var responsed = json.decode(response.body);
         if(responsed['status']==1){
           print("no data");
           data = true;
           error = true;
           load = true;
         }else
         if(responsed['status']==2){
           print("2");
           load = true;
           error  = true;
           data = false;
           listpending = responsed['result'];
           print(listpending);
         }
         else{
           print("else");
           load  = true;
           error = false;
         }
       }else{
         load = true;
         error = false;
       }
      });
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        error  = false;
      });
    }
  }
  getSp()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString("customer_id")??"0";
    login = prefs.getBool('login')??false;
    if(login){
      getdata(customer_id);
    }else{
      Fluttertoast.showToast(msg: "Login First to view Orders!");
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(3))).then((value) => getSp());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSp();
  }
  paynow(String id, String price) async{
    var order = [{'id': id}];
    var total = price;
    print(order);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> PaymentScreen(amount: total.toString(),order : order)));
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width/392;
    double height = MediaQuery.of(context).size.height/850;
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        iconTheme:IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(widget.title,style: TextStyle(color:Theme.of(context).accentColor),),
      ),
      body:   login ? load ? error ? data?Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("images/empty.png",width: 200,height: 200,)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("No orders Yet!!",style: TextStyle(fontSize: 18),),),
            ),
          ],
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        reverse: true,
        itemCount: listpending.length,
        itemBuilder: (BuildContext context,int index){
          var orderdate = listpending[index]['doa'].toString();
          print("/////////////////////////////////");
          print("date: "+listpending[index]['doa'].toString());
          var prevMonth = new DateTime(int.parse(orderdate.substring(0,4)),int.parse(orderdate.substring(5,7)), int.parse(orderdate.substring(8,10)));
          var formatter = DateFormat("dd-MMMM-y");
          var status_id = listpending[index]['status_id'].toString();
          var status = Container();
          if(status_id == '1'){
            status =  Container(
                height: 25,
                width: 80,
                decoration: new BoxDecoration(
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 2.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: Center(child: Text("Pending",style: TextStyle(color:Colors.white),)));
          }
          else if(status_id == '2'){
            status =   Container(
                height: 25,
                width: 80,
                decoration: new BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 2.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: Center(child: Text("Dispatch",style: TextStyle(color:Colors.white),)));
          }
          else if(status_id == '3'){
              status =   Container(
                  height: 25,
                  width: 80,
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Center(child: Text("Delivered",style: TextStyle(color:Colors.white),)));
            }
          else if(status_id == '4'){
                status =   Container(
                    height: 25,
                    width: 80,
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      boxShadow:[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        ),
                      ],
                    ),
                    child: Center(child: Text("Cancelled",style: TextStyle(color:Colors.white),)));
              }
          else if(status_id == '5'){
            status =   Container(
                height: 25,
                width: 80,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  boxShadow:[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 2.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Center(child: Text("Return...",style: TextStyle(color:Colors.white),)));
          }
          else if(status_id == '6'){
            status =   Container(
                height: 25,
                width: 80,
                decoration: new BoxDecoration(
                  color: Colors.brown,
                  boxShadow:[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 2.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Center(child: Text("Returned",style: TextStyle(color:Colors.white),)));
          }
          orderdate = formatter.format(prevMonth).toString();
          return GestureDetector(
            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(listpending[index]["p_id"].toString())));
            listpending[index]["status_id"].toString()!="4" && listpending[index]["payment_mode"].toString()=="2" && listpending[index]["paytm_order_id"].toString()=="null"?
                print("Not paid!!")
                : _showModal(context,listpending[index]["order_id"].toString());
            },
            child: Padding(
              padding: EdgeInsets.only(top:2.0,left:8,right: 8),
              child: Card(
                elevation: 5,
                color: Colors.white,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:8.0,right: 8,top:8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
//                          color: Theme.of(context).primaryColor,
//                          width: 100,
                                  width: MediaQuery.of(context).size.width/4,
                                  height: 130,
                                  child: Stack(
                                    children: <Widget>[
                                      Center(child: Padding(
                                        padding: const EdgeInsets.only(top:10.0),
                                       child: FadeInImage.assetNetwork(placeholder: 'images/no-img.png', image: listpending[index]['img_url'].toString())
                                        // child: Image.asset("Images/empty.png"),
                                      )),
                                    ],
                                  )
                              ),
                              Container(
//                          color: Theme.of(context).accentColor,
                                padding: EdgeInsets.only(left:8,top: 4),
//                          width: 180,
                                width: MediaQuery.of(context).size.width/2.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      child: Text(listpending[index]['name'].toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      width: 200*width,),
                                    Text(""),
                                    SizedBox(
                                      child: InkWell(
                                        onTap: (){
//                                      UrlLauncher.launch("tel:"+listpending[index]["contact"].toString());
                                        },
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(listpending[index]["brand"].toString()+", ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 14)),
                                            Text(listpending[index]["description"].toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                      width: 200*width,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text("Date of Order: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(orderdate),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text("Order ID: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(listpending[index]["payment_mode"].toString()!="2"?listpending[index]["order_id"].toString():listpending[index]["paytm_order_id"].toString()),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.black26
                                          ),
                                          right: BorderSide(
                                              color: Colors.black26
                                          )
                                      )
                                  ),
                                  height: 100,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Customer Name",style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      Text(listpending[index]["customer_name"].toString())
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.black26
                                          )
                                      )
                                  ),
                                  height: 100,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Customer Address",style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:2.0,left:2,right: 1),
                                        child: Text(listpending[index]['address'],maxLines: 3,overflow: TextOverflow.ellipsis,),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.black26
                                      ),
                                    )
                                ),
                                height: 70,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Payment",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Text(listpending[index]["payment_mode"].toString()=="2"?listpending[index]["paytm_order_id"].toString()!="null"?"PREPAID":"PAY NOW":"COD"),
                                  ],
                                ),
                              )),
                              Expanded(child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          color: Colors.black26
                                      ),
                                      top: BorderSide(
                                          color: Colors.black26
                                      ),
                                      right: BorderSide(
                                          color: Colors.black26
                                      ),
                                    )
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Delivery",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Home Delivery"),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              Expanded(child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.black26
                                        )
                                    )
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Text(utf8.decode([0xE2,0x82,0xB9])+ " "+listpending[index]['selling_price'].toString()),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          listpending[index]["status_id"].toString()=="1"?
                          listpending[index]["paytm_order_id"].toString()=="null" && listpending[index]["payment_mode"].toString()=="2"?
                          Column(
                            children: [
                              Container(
                                color: Colors.blueGrey,
                                height: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      child: Text("Pay Now",style: TextStyle(color:Constants.ACCENT_COLOR),),
                                      color: Constants.PRIMARY_COLOR,
                                      onPressed: (){
                                        print("PayNow");
                                        paynow(listpending[index]["order_id"].toString(), listpending[index]["selling_price"].toString());
                                      },
                                    ),
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text("Cancel Order",style: TextStyle(color:Constants.PRIMARY_COLOR),),
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return AlertDialog(
                                              title: Text("Cancel Order?"),
                                              content: Container(
                                                child: Wrap(
                                                  direction: Axis.vertical,
                                                  children: <Widget>[
                                                    SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          "Do you want to Cancel Order?",
                                                          maxLines: 3,)),
                                                    Text(""),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Total Amount: "),
                                                        Text("\u20B9 " +
                                                            listpending[index]['selling_price'].toString(),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18),)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                // usually buttons at the bottom of the dialog
                                                new FlatButton(
                                                  child: new Text("No"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: new Text("Yes"),
                                                  onPressed: () {
                                                    String type;
                                                    setState(() {
                                                    });
                                                    updateOrder(listpending[index]["order_id"].toString(),"4");
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          :Center():Center(),
                        ],
                      ),
                    ),
                    listpending[index]["status_id"].toString()=="1"?
                    listpending[index]["paytm_order_id"].toString()=="null" && listpending[index]["payment_mode"].toString()=="2"
                        ?Container(
                      // height: 20,
                      color:Colors.red,
                      child:Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text("*To confirm Order Pay Now", style: TextStyle(fontSize:12,color:Colors.white),),
                      ),
                    ):Center():Center(),
                    Align(
                        alignment: Alignment.topRight,
                        child: status),
                  ],
                ),
              ),
            ),
          );
        },
      )
          : Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Try Again!"),
            Text(""),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side: BorderSide(color: Theme.of(context).accentColor)),
              onPressed: (){
                // getdata(vendor_id);
              },
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0,12,12,12),
                child: Text("Retry",style: TextStyle(color:Theme.of(context).accentColor,fontSize: 16),),
              ),
            ),
          ],
        ),),)
          : Container(
              child: Center(
                        child: ProgressDailog().Progress(context),
                      ),
              )
          : Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Login to Check Orders!"),
            Text(""),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),side: BorderSide(color: Theme.of(context).accentColor)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(3))).then((value) => getSp());
              },
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0,12,12,12),
                child: Text("Retry",style: TextStyle(color:Theme.of(context).accentColor,fontSize: 16),),
              ),
            ),
          ],
        ),),)
    );
  }
  updateOrder(id,type)async{
    print("ID: "+id);
    print("TYPE: "+type);
    setState(() {
      load = false;
    });
    http.Response response = await http.post(
        API.updateOrderStatus,
        body: {
          'authkey' : API.key,
          'order_id' : id,
          'status_id':type,
        }
    );
    setState(() {
      Navigator.of(context).pop();
      print("POP");
      var responsed = json.decode(response.body);
      print(response.body);
      if(responsed['status']==1){
        // data = true;
        load = true;
      }else
      if(responsed['status']==2){
        print("2");
        load = true;
        // data = false;
        getdata(customer_id);
        Fluttertoast.showToast(msg: responsed['message'].toString());
      }
      else{
        print("else");
        load  = true;
        Navigator.pop(context);
      }
      // initState();
    });
  }
}

class MainBottomSheet extends StatefulWidget {

  String id = "0";
  MainBottomSheet(this.id){
    print(id);
  }

  @override
  _MainBottomSheetState createState() => _MainBottomSheetState();
}

class _MainBottomSheetState extends State<MainBottomSheet> {

  String id = "0";
  bool detail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
    fetchOrderDetail();
  }

  var load = false;
  var data;
  var data1;
  int status=0;
  var different;

  fetchOrderDetail() async {
    setState(() {
      load = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var vendor = prefs.getString("vendor_id") ?? '0';

    // try{
      http.Response response = await http.post(
          API.fetchmyordersdetailed,
          body: {
            'authkey' : API.key,
            'order_id': widget.id,
          });
      // print(response.body);
      setState(() {
        load = true;
        if (response.statusCode == 200 || response.statusCode == 201) {
          var resd = jsonDecode(response.body);
//        print(resd);
          if (resd["status"] == 2) {
            data = resd["result"];
            data1 = resd["result"];
            print("Data is here: ");
            print(data);
            setState(() {
              String sstatus = data[0]["status_id"].toString();
              status = int.parse(sstatus.toString());
              // status = 6;
              String doa =data[0]['doa'].toString();
              String year = doa.substring(0,4);
              String month = doa.substring(5,7);
              String days = doa.substring(8,10);
              final birthday = DateTime(int.parse(year), int.parse(month), int.parse(days));
              final date2 = DateTime.now();
              setState(() {
                different = date2.difference(birthday).inDays;
                // different = 9;
              });
              print("Different = "+different.toString());
            });
            print(status);
          }
          else {
            Fluttertoast.showToast(msg: "Unable to fetch Data");
          }
        }
      });
    // }catch(e){
    //   Fluttertoast.showToast(msg: e.toString());
    //   // Navigator.pop(context);
    //   print(e.toString());
    // }
  }
  updateOrder(String id,String type)async{
    setState(() {
      load = false;
      print("got data");
      print(type);
    });
    try{
      http.Response response = await http.post(
          API.updateOrderStatus,
          body: {
            'authkey' : API.key,
            'order_id' : id,
            'status_id':type,
          }
      );
      print(response.body);
      setState(() {
        Navigator.of(context).pop();
        var responsed = json.decode(response.body);
        if(responsed['status']==1){
          print("no data");
          data = true;
          load = true;
        }else
        if(responsed['status']==2){
          print("2");
          load = true;
          data = false;
          Fluttertoast.showToast(msg: responsed['message'].toString());
        }
        else{
          print("else");
          load  = true;
          Navigator.pop(context);
        }
        // initState();
      });
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        Navigator.pop(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height / 1.1,
      child: Stack(
        children: <Widget>[
          loadalert ? Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 1.1,
            child: load ? DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Order No. " + id),
                ),
                body: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                             child: Line(status),
                            // child: Line(int.parse(data1[0]['status_id'])),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 4.0, right: 4, top: 8, bottom: 8),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12))
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 12, bottom: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Theme
                                              .of(context)
                                              .accentColor,
                                          child: CircleAvatar(
                                              radius: 33,
                                              backgroundColor: Colors.white,
                                              child: Image.network(
                                                API.BaseUrl+"product/fetch_file_img?img=default-user.png",
                                                width: 60, height: 50,)
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(data1[0]['customer_name']
                                                  .toString(),
                                                style: TextStyle(fontSize: 24),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,),
                                              Text(data1[0]['mobile'].toString(),
                                                style: TextStyle(fontSize: 14),),
//                                            Text("goutamjaiswal214@gmail.com",),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 4.0, right: 4, top: 8, bottom: 8),
                          child: Container(
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 6.0),
                                      child: Text("Delivery Address:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                    ),
                                    SizedBox(
                                        width: 200,
                                        child: Text(data1[0]['address'])),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 4.0, right: 4, top: 8, bottom: 8),
                          child: Container(
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Image.network(data1[0]['img_url'].toString()),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 6.0),
                                            child: Text("Product Details:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(data1[0]['name'].toString(),maxLines: 3,style: TextStyle(color: Constants.PRIMARY_COLOR,fontWeight: FontWeight.bold,fontSize: 20),)),
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  // color:Colors.red,
                                                  color: Color(int.parse("0xff"+data1[0]['color_code'].toString())),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("Size : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                                              Text(data1[0]['size_name'].toString().toUpperCase(),style: TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: GestureDetector(
                            onTap: (){
                              status==1 || status==2 || (status==3 && different < 11)?showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: status<3?Text("Cancel Order?"):status==3?Text("Return Product"):Center(),
                                    content: loadalert ? Container(
                                      child: Wrap(
                                        direction: Axis.vertical,
                                        children: <Widget>[
                                          SizedBox(
                                              width: 200,
                                              child: status<3 ?Text(
                                                "Do you want to Cancel Order?",
                                                maxLines: 3,):status==3?Text("Do you want to Return Product?"):Text("")),
                                          Text(""),
                                          Row(
                                            children: <Widget>[
                                              Text("Total Amount: "),
                                              Text("\u20B9 " +
                                                  data1[0]['selling_price']
                                                      .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ) : ProgressDailog().Progress(context),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      new FlatButton(
                                        child: new Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: new Text("Yes"),
                                        onPressed: () {
                                          String type;
                                          setState(() {
                                            if(status<3){
                                              type = "4";
                                            } else if(status == 3){
                                              type = "5";
                                            }
                                          });
                                          updateOrder(data1[0]['order_id'].toString(), type.toString());
                                          setState(() {
                                            if(status<3){
                                              status =4;
                                            } else if(status == 3){
                                              status = 5;
                                            }
                                          });
//                                                Fluttertoast.showToast(msg: "Yes Order Delivered");
//                                         if(data1[0]['status_id']==1){
//                                           updateStatus(2, data1[0]['order_id']);
//                                         }else if(data1[0]['status_id']=="2"){
//                                           updateStatus(3, data1[0]['order_id']);
//                                         }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ):status==4?Fluttertoast.showToast(msg: "You Canceled the order!")
                                  :status==5?Fluttertoast.showToast(msg: "Applied for return!!")
                                  :Fluttertoast.showToast(msg: "Cannot Return The Product");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  border: Border.all(color: Colors.green)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:   Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("\u20B9 " + data1[0]['selling_price'],
                                      style: TextStyle(color: Constants.PRIMARY_COLOR,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: status<3 || status ==4?Colors.red:status>4?Colors.grey:Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            border: Border.all(color: Colors.green)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            children: <Widget>[
                                              status<3?Text("Cancel Order",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold),)
                                                  :status ==4?Text("Canceled",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold),)
                                                  :status==3&& different <11?Text("Return",style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),)
                                                  :status==5?Text("Applied To Return",overflow: TextOverflow.ellipsis,style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),)
                                                  :status == 6?Text("Returned",overflow: TextOverflow.ellipsis,style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),):Text("Delivered",overflow: TextOverflow.ellipsis,style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ) : ProgressDailog().Progress(context),
          ):ProgressDailog().Progress(context),
        ],
      ),
    );
  }

  var loadalert = true;
}
