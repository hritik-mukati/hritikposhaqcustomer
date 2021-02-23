// import 'package:dvendor/CheckOut.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:dproject/NewAddress.dart';
import 'package:dproject/ProgressDailog.dart';
import 'package:dproject/WishList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'CheckOut.dart';
import 'Constants.dart';
import 'login.dart';
class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List <String> list1 =["one","two","three","four","five"];
  bool loding = false,login = false,no_data = true;
  int total = 0;
  String address;
  String customer_id,cart_data,cart_color,cart_size,cart_size_name;
  List ids,clrs,sizes,sizes_name;
  List<dynamic> cart = List();
  var Custom_cart;
  getSp()async{
    print("In sp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getBool('login')??false;
    Custom_cart = prefs.getString('Custom_cart') ?? [];
    if(Custom_cart.length!=0){
      Custom_cart = jsonDecode(Custom_cart);
    }
    if(login){
      print("login "+ login.toString());
      get_cart();
    }else{
      print("login "+ login.toString());
      if(Custom_cart.length!=0){
        print("data in ofline cart");
        print(Custom_cart);
        get_static_cart();
      }else{
        print("in cart empty, and login false");
        setState(() {
          loding = true;
          no_data = true;
        });
      }
    }
  }
  get_cart()async{
    print("get_cart calling");
    var body = {
      'authkey' : API.key,
      'customer_id' : customer_id
    };
    http.Response response = await http.post(
      API.fetch_cart,
      body: body,
    );
    print(response.body);
    if(response.statusCode==200){
      setState(() {
        total = 0;
        var responsed = json.decode(response.body);
        if(responsed['status'] == 2){
          cart = responsed['result'];
          print(cart.toString());
          for(int i=0;i<cart.length;i++){
            total = total+int.parse(cart[i]['price']);
          }
          print("total: "+total.toString());
          no_data = false;
        }else{
          no_data = true;
          cart = List();
        }
        loding = true;
      });
    }else{
      setState(() {
        loding = true;
        Fluttertoast.showToast(msg: "Error Occured!!");
      });
    }
  }
  get_static_cart()async {
    print("Fetching Data : ");
    for(int i=0;i<Custom_cart.length;i++){
      http.Response response =  await http.post(
          API.fetch_detailed,
          body: {
            'authkey' : API.key,
            'p_id' : Custom_cart[i]['p_id'].toString(),
          }
      );
      print(response.body);
      setState(() {
        var responsed = json.decode(response.body);
        no_data =false;
        cart.add(responsed['result'][0]);
        total = total+int.parse(responsed['result'][0]['price']);
      });
      // getProduct(ids[i]);
      if(i == Custom_cart.length-1){
        setState(() {
          loding = true;
        });
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSp();
  }
  @override
  var nae ="0",sizesn="0",clrsn="0",sizes_namen="0";
  Widget build(BuildContext context) {
    print("no data: "+no_data.toString());
    return loding?no_data?
    Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
        title: Text("My Cart"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border,color: Constants.ACCENT_COLOR,),
            onPressed: (){
              if(login==false){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Login(2)));
              }else {
                Navigator.push(context,MaterialPageRoute(builder: (context) => WishList()));
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Constants.ACCENT_COLOR,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/empty.png",height: 150,),
              Text(" "),
              Text("Nothing In cart!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    )
        :Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
        title: Text("My Cart"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border,color: Constants.ACCENT_COLOR,),
            onPressed: (){
              if(customer_id=="0"){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Login(2)));
              }else {
                Navigator.push(context,MaterialPageRoute(builder: (context) => WishList()));
              }
            },
          ),
        ],
      ),
      body: Container(
         color: Colors.white24,
         // color: Constants.PRIMARY_COLOR,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: Custom_cart.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Card(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
//                                color: Colors.red,
                                    child: Image.network(
                                        login?
                                        cart[index]['img_url'].toString()
                                        // "https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png"
                                            : cart[index]['images'][0]['img_url']),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 8, 5, 5),
//                                color: Colors.yellow,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(login?cart[index]['name']:cart[index]['name'],maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(login?"Rs "+cart[index]['price']:"Rs "+cart[index]['price'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                            Padding(
                                              padding: const EdgeInsets.only(left:4.0),
                                              child: Text(login?"Rs "+cart[index]['mrp']:"Rs "+cart[index]['mrp'],style: TextStyle(decoration:TextDecoration.lineThrough,fontSize: 14,color: Colors.grey,)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                color: Colors.green,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left:6.0,right: 6.0),
                                                  child: Text((100*((int.parse(cart[index]['mrp'])-int.parse(cart[index]['price']))/int.parse(cart[index]['mrp']))).toStringAsFixed(1)+"% Off",style: TextStyle(fontSize: 12,color: Colors.white,)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(3),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child:Row(
                                                children: <Widget>[
                                                  Text("Size: ",style: TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,),
                                                  Container(
                                                      width: 50,
                                                      child:Text(login?cart[index]['size']:Custom_cart[index]['size_name'].toString(),overflow:TextOverflow.fade,maxLines: 1,style: TextStyle(fontSize: 15),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child:Padding(
                                                padding:  EdgeInsets.only(left:8.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text("Color: ",style:TextStyle(fontSize: 15),),
                                                    Text(""),
                                                    Container(
                                                      height: 13,
                                                      width: 13,
                                                      color: login?Color(int.parse("0xff"+cart[index]['color_code'])):Color(int.parse("0xff"+Custom_cart[index]['color'].toString())),
                                                    ),
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
                              ],
                            ),
                          ),
                          Align(
                            child: IconButton(
                              icon: Icon(Icons.delete_outline,color: Colors.red,),
                              onPressed: (){
                                print("delete from: "+index.toString());
                                showDialog(context: context,
                                  child: AlertDialog(
                                    title: Text("Delete From Cart"),
                                    actions: [
                                      RaisedButton(
                                        child: Text("No"),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      RaisedButton(
                                        child: Text("Yes"),
                                        onPressed: (){
                                          // Navigator.of(context).pop();
                                          remove_from_cart(index.toString(),login?cart[index]['cart_id'].toString():"0",cart[index]['price']);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            alignment: Alignment.bottomRight,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              // color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Constants.ACCENT_COLOR,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: adds?FlatButton(
                    color: Constants.ACCENT_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left:15.0,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Rs. "+total.toString(),style: TextStyle(fontSize:18.0,color: Constants.PRIMARY_COLOR),),
                          Container(
                              decoration: BoxDecoration(
                                color:Constants.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Getting Address...",style: TextStyle(fontSize:18.0,color: Constants.ACCENT_COLOR,fontWeight: FontWeight.bold),),
                              )),
                        ],
                      ),
                    ),
                    onPressed: (){
                      Fluttertoast.showToast(msg: "Please Wait!!");
                    },
                  ):FlatButton(
                    color: Constants.ACCENT_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left:15.0,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Rs. "+total.toString(),style: TextStyle(fontSize:18.0,color: Constants.PRIMARY_COLOR),),
                          Container(
                              decoration: BoxDecoration(
                                color:Constants.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Check Out",style: TextStyle(fontSize:18.0,color: Constants.ACCENT_COLOR,fontWeight: FontWeight.bold),),
                          )),
                        ],
                      ),
                    ),
                    onPressed: (){
                      if(login == false){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(1))).then((value) => getSp());
                      }else {
                        checkout();
                      }
                      },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ):Container(color:Colors.white,child: Center(child: ProgressDailog().Progress(context),));
  }
  bool adds =false;
  checkout()async{
    print("checkout");
    setState(() {
      adds = true;
    });
    try{
      http.Response res= await http.post(
          API.getaddress,
          body:{
            'authkey' : API.key,
            'customer_id' : customer_id,
          }
      );
      print(res.body);
      setState(() {
        adds = false;
        var resp = json.decode(res.body);
        if(resp['status']==1){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>NewAddress(0)));
        }if(resp['status']==2){
          print("Got address");
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  CheckOut(resp['result'][0]['name'],resp['result'][0]['address'],resp['result'][0]['pincode'],resp['result'][0]['address_id'],resp['result'][0]['mobile'])));
        }
      });
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),backgroundColor: Colors.red);
      setState(() {
        adds = false;
      });
    }
  }
  remove_from_cart(String index,String cart_id,String price)async{
    print("deleting price: "+price);
    if(login){
      Navigator.pop(context);
      setState(() {
        loding = false;
      });
      http.Response response = await http.post(
          API.delete_cart,
          body:{
            'authkey' : API.key,
            'cart_id' : cart_id,
          }
      );
      print(response.body);
      setState(() {
        var res = json.decode(response.body);
        if(res['status']==2) {
          Navigator.of(context).pop();
          get_cart();
        }else if(res['status']==1){
          Fluttertoast.showToast(msg: res['message']);
        }
      });
    }
    else{
      print("notlogin delete at"+index);
     setState(() {
       Custom_cart.removeAt(int.parse(index));
       cart.removeAt(int.parse(index));
       Navigator.of(context).pop();
       print(Custom_cart);
       print("-----------------------");
       print("Cart Length: "+Custom_cart.length.toString());
       if(Custom_cart.length>0){
         settingSp(Custom_cart, price);
       }else{
         deleteSp();
       }
     });
    }
  }
  settingSp(var Custom_cart, String price)async{
    print("in setting sp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Custom_cart", jsonEncode(Custom_cart));
    print("saved to sp");
    total= 0;
    getSp();
  }
  deleteSp()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("Custom_cart");
    getSp();
    setState(() {
      no_data=true;
    });
  }
  setSp(String nae,String clrsn,String sizesn,String sizes_namen)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("cart_data", nae);
      pref.setString('cart_color', clrsn);
      pref.setString('cart_size', sizesn);
      pref.setString('cart_size_name', sizes_namen);
    });
  }
}
