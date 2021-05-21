import 'dart:convert';

import 'package:dproject/ProgressDailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'Constants.dart';
import 'Detailed.dart';
import 'Search.dart';
class BannerPage extends StatefulWidget {
  String title,k;
  BannerPage(this.title,this.k);
  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  bool network = true,load = false,data = false;
  var products = List();
  var responsed;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    // print(widget.title.substring(0,2));
  }
  Future<void>getdata()async{
    setState(() {
      load = false;
    });
    print("called");
    try{
      if(widget.k=="0"){
        int eoff=0;
        int soff =int.parse(widget.title.substring(0,2));
        setState(() {
          if(soff==40){
            eoff = 59;
          }else if(soff == 60){
            eoff = 79;
          }else if(soff == 80){
            eoff = 100;
          }
        });
        print("soff" + soff.toString());
        print("eoff" + eoff.toString());
        http.Response response = await http.post(
            API.fetchbannerper,
            // "https://www.amigodevelopers.tech/dproject_dev/index.php/Product/dashboard_getProductByPercent",
            body: {
              'authkey' : API.key,
              'e_off' : eoff.toString(),
              's_off' : soff.toString(),
            }
        );
        setState(() {
          print("getting result");
          print(response.body);
          if(response.statusCode==200){
            responsed = json.decode(response.body);
          }else{
            setState(() {
              load = true;
              network  = true;
              data  = false;
            });
          }
        });
      }else if(widget.k=="1"){
        int eoff=0;
        int soff =int.parse(widget.title.substring(6,9));
        if(soff==299){
          eoff = 0;
        }else if(soff == 499){
          eoff = 300;
        }else if(soff == 799){
          eoff = 500;
        }
        print("soff" + soff.toString());
        print("eoff" + eoff.toString());
        http.Response response = await http.post(
            API.fetchbannerpirce,
            body: {
              'authkey' : API.key,
              's_price' : eoff.toString(),
              'e_price' : soff.toString(),
            }
        );
        setState(() {
          print("got result");
          print(response.body);
          if(response.statusCode==200){
            responsed = json.decode(response.body);
          }else{
            setState(() {
              load = true;
              network  = true;
              data  = false;
            });
          }
        });
      }
      print(responsed);
      if(responsed['status']==1){
        setState(() {
          load = true;
          network  = false;
          data  = false;
        });
      }else if(responsed['status']==2){
        setState(() {
          load = true;
          network  = false;
          data  = true;
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
          print("----------------");
          print(products[0]['img']);
        });
      }else{
        setState(() {
          load = true;
          network  = true;
          data  = false;
        });
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
      print("TRy:  "+e.toString());
      setState(() {
        load = true;
        network  = true;
        data  = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: load?network?Center(
        child: Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Network Error Occure Plz Check Network And reload!",style: TextStyle(fontSize: 18,color: Constants.PRIMARY_COLOR),),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 100,
                  child: RaisedButton(
                    onPressed: (){
                      print("reload!!");
                      getdata();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.refresh,size: 18,color: Constants.ACCENT_COLOR,),
                        Text("  Reload",style: TextStyle(color: Constants.ACCENT_COLOR),),
                      ],
                    ),
                    color: Constants.PRIMARY_COLOR,
                  ),
                ),
              ),
            ],
          ),
        ),
      ):
          data?Scaffold(
//             appBar: AppBar(
//               backgroundColor: Constants.APP_BAR_COLOR,
//               title: Text("New Products",style: TextStyle(color: Constants.PRIMARY_COLOR),),
//               elevation: 0.0,
// //        iconTheme: IconThemeData(color: Constants.PRIMARY_COLOR),
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back_ios, color: Constants.PRIMARY_COLOR),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.search,color: Constants.PRIMARY_COLOR,),
//                   onPressed: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
//                     // Fluttertoast.showToast(msg: "Search..");
//                   },
//                 ),
//               ],
//             ),
            body:
            RefreshIndicator(
              onRefresh: getdata,
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
                                                image:products[index]['img']!=null?NetworkImage(products[index]['img'].toString()):AssetImage('images/no-img.png'),
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
          ):Container(
            color: Colors.white,
            child:Center(
              child: Image.asset("images/coming-soon.png"),
            ),
          ):
      Container(
        child: ProgressDailog().Progress(context),
      ),
    );
  }
}
