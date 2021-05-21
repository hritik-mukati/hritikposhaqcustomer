import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'Detailed.dart';
import 'ProgressDailog.dart';
import 'Search.dart';
class Products extends StatefulWidget {
  String cat_id;
  Products(String this.cat_id);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool loding = false,data = true,nodata = false;
  String header = "Products";
  var responsed;
  var products = List();
  Future<void> getProducts()async{
    setState(() {
      nodata = false;
    });
    try{
      http.Response response =  await http.post(
          API.fetch_product,
          body: {
            'authkey' : API.key,
            'cat_id' : widget.cat_id,
          }
      );
      // print(response.body);
      if(response.statusCode!=200){
        setState(() {
          nodata = true;
        });
      }
      else{
        setState(() {
          responsed = json.decode(response.body);
          loding = true;
          if(responsed['status'] == 2){
            for(int i=0; i<responsed['result'].length;i++){
              if(responsed['result'][i]['is_active']!="0"){
                products.add(responsed['result'][i]);
              }
              print("actives: ");
              print(products);
            }
            data = true;
            if(products.length==0){
              setState(() {
                data = false;
              });
            }
          }else{
            data = false;
          }
        });
      }
    }catch(e){
      Fluttertoast.showToast(msg: "Network Error");
      setState(() {
        nodata = true;
      });
    }
  }
  getSP()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      getProducts();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
    print("Cat_id: "+widget.cat_id);
  }
  @override
  Widget build(BuildContext context) {
    return nodata?Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Constants.ACCENT_COLOR,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Network Issues please reload"),
            RaisedButton(
              child: Text("Reload"),
              onPressed: (){
                getProducts();
              },
            ),
          ],
        ),
      ),
    ):loding?Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.APP_BAR_COLOR,
        title: Text(header,style: TextStyle(color: Constants.PRIMARY_COLOR),),
        elevation: 0.0,
//        iconTheme: IconThemeData(color: Constants.PRIMARY_COLOR),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Constants.PRIMARY_COLOR),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,color: Constants.PRIMARY_COLOR,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
              // Fluttertoast.showToast(msg: "Search..");
            },
          ),
        ],
      ),
      body:
      RefreshIndicator(
        onRefresh: getProducts,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Constants.ACCENT_COLOR,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                    padding:EdgeInsets.fromLTRB(3,15,3,0),
                    child: data?GridView.builder(
                        itemCount: products.length,
                        gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height/1.1),
                        ),
                        itemBuilder: ( BuildContext context,int index){
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: (){
                                print(products[index]['p_id']);
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Detailed(products[index]['p_id'])));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image:DecorationImage(
                                          image:NetworkImage(products[index]['img'].toString()),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      // height: 186,
//                                    color: Colors.green,
                                    ),
                                  ),
                                  Container(
                                    height:90,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            children: [
                                              Text(" \u20B9"+products[index]['price'],style: TextStyle(color: Constants.PRIMARY_COLOR,fontWeight: FontWeight.bold,fontSize: 18),),
                                              Text(" "),
                                              Text(" \u20B9"+products[index]['mrp'],style: TextStyle(color: Colors.grey,fontSize: 16,decoration: TextDecoration.lineThrough),),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left:5.0,right: 5,top:10),
                                          child: Text(products[index]['brand'],style: TextStyle(fontSize: 15,color: Constants.PRIMARY_COLOR),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left:5.0,right: 5,top:10),
                                          child: Container(
                                            width:MediaQuery.of(context).size.width,
//                                  height:MediaQuery.of(context).size.height,
                                            height:20,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: products[index]['colors'].length,
                                                itemBuilder: (BuildContext context,int indexx) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Container(
                                                      width: 15,height: 10,
                                                      decoration: BoxDecoration(
                                                        color: Color(int.parse("0xff"+products[index]['colors'][indexx]['color_code'])),
                                                        border: Border.all(
                                                          color: Constants.PRIMARY_COLOR,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        :Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Constants.ACCENT_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height:150,width: 150,child: Image.asset("images/empty.png")),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Text("No Products Found!",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    ):Scaffold(
      body: Container(
        child: Center(
          child: ProgressDailog().Progress(context),
        ),
      ),
    );
  }
}