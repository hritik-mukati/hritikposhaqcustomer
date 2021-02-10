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
  getSp()async{
    print("In sp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString('customer_id')??"0";
    cart_data = prefs.getString('cart_data')??"0";
    cart_color = prefs.getString('cart_color')??"0";
    cart_size = prefs.getString('cart_size')??"0";
    cart_size_name = prefs.getString('cart_size_name')??"0";
    login = prefs.getBool('login')??false;
    // print(login.toString());
    // print(customer_id);
    if(cart_data!="0"){
      ids= cart_data.split(',');
      clrs =cart_color.split(',');
      sizes =cart_size.split(',');
      sizes_name =cart_size_name.split(',');
      print("P_ids: "+ids.toString());
      print("sizes: "+sizes_name.toString());
      print("colors: "+clrs.toString());
      print("login: "+login.toString());
      if(login==false){
        get_static_cart();
      }else{
        addItemToCart();
      }
    }else{
      if(login){
        get_cart();
      }else{
        setState(() {
          loding = true;
          no_data = true;
        });
      }
    }
  }
  addItemToCart()async{
    var arr = List<Map>();
    for(int i = 0;i<ids.length;i++){
      Map m = {
        "p_id":ids[i],
        "size_id":sizes[i]
      };
      arr.add(m);
      print(arr);
      print("adding item to cart");
//add all items
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
      var res = json.decode(response.body);
      if(res['status']==2){
        print("Data Added Succesfully");
        get_cart();
        deleteSp();
      }else if(res['status']==1){
        deleteSp();
        get_cart();
      }
      else{
        Fluttertoast.showToast(msg: "Error in loading!!",backgroundColor: Constants.PRIMARY_COLOR);
        no_data = true;
      }
    });
    // get_cart();
    // deleteSp();
  }
  get_cart()async{
    http.Response response = await http.post(
      API.fetch_cart,
      body: {
        'authkey' : API.key,
        'customer_id' : customer_id,
      }
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
  delete_cart(String cart_id)async{
  }
  get_static_cart()async {
    for(int i=0;i<ids.length;i++){
      http.Response response =  await http.post(
          API.fetch_detailed,
          body: {
            'authkey' : API.key,
            'p_id' : ids[i].toString(),
          }
      );
      // print(response.body);
      setState(() {
        var responsed = json.decode(response.body);
        loding = true;
        no_data =false;
        cart.add(responsed['result'][0]);
        total = total+int.parse(responsed['result'][0]['price']);
      });
      // getProduct(ids[i]);
      print("id is: "+ids[i]);
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
//                  itemCount: list1.length,
                  itemCount: cart.length,
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
                                                      child:Text(login?cart[index]['size']:sizes_name[index].toString(),overflow:TextOverflow.fade,maxLines: 1,style: TextStyle(fontSize: 15),),
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
                                                      color: login?Color(int.parse("0xff"+cart[index]['color_code'])):Color(int.parse("0xff"+clrs[index].toString())),
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
                                          Navigator.of(context).pop();
                                          remove_from_cart(index.toString(),login?cart[index]['cart_id'].toString():"0");
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
  remove_from_cart(String index,String cart_id)async{
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
          get_cart();
        }else if(res['status']==1){
          Fluttertoast.showToast(msg: res['message']);
        }
      });
    }
    else{
     setState(() {
       cart.removeAt(int.parse(index));
       ids.removeAt(int.parse(index));
       print("ids"+ids.toString());
       clrs.removeAt(int.parse(index));
       print("clrs"+clrs.toString());
       sizes.removeAt(int.parse(index));
       print("sizes"+sizes.toString());
       sizes_name.removeAt(int.parse(index));
       print("size name" + sizes_name.toString());
       if(ids.length>0){
         for(int i = 0;i<ids.length;i++){
           if(nae == "0"){
             nae = ids[i];
             clrsn= clrs[i];
             sizesn = sizes[i];
             sizes_namen = sizes_name[i];
           }else{
             nae  = nae + ","+ids[i];
             clrsn= clrsn+ ","+clrs[i];
             sizesn = sizesn+","+sizes[i];
             sizes_namen = sizes_namen+","+sizes_name[i];
           }
         }
         getSp();
       }else{
         deleteSp();
       }
       print("ids: "+nae);
       print("colors: "+clrsn);
       print("sizes: "+sizesn);
       print("sizes name: "+sizes_namen);
       setSp(nae,clrsn,sizesn,sizes_namen);
     });
    }
  }
  deleteSp()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("cart_data");
    pref.remove("cart_color");
    pref.remove("cart_size");
    pref.remove("cart_size_name");
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
