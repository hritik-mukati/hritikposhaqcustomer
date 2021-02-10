import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';
import 'Detailed.dart';
import 'ProgressDailog.dart';
class Searchde extends StatefulWidget {
  String name;
  Searchde(this.name);
  @override
  _SearchdeState createState() => _SearchdeState();
}

class _SearchdeState extends State<Searchde> {
  bool data=true;
  var inactive_data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
  }
  String customer_id;
  getSP()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString("vendor_id");
    search(widget.name);
    print(widget.name);
  }
  void search(String word)async{
    setState(() {
      data = true;
    });
    final http.Response response = await http.post(
        API.search2,
        headers: <String, String>{
          'Content_Type': 'application/json; charset=UTF-8'
        },
        body: {
          'authkey' : API.key,
          // 'vendor_id' : vendor_id,
          'name':word,
        });
    print("result!!!!");
    print(response.body);
    setState(() {
      data = false;
      if(response.statusCode==200){
        var res = json.decode(response.body);
        if(res['status']!=1){
          inactive_data = res['result'];
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Searched Products"),
      ),
      body: Container(color: Colors.white,
        child: data?Center(
          child: ProgressDailog().Progress(context),)
            :inactive_data!=null?ListView.builder(
                itemCount: inactive_data.length,
                itemBuilder: (BuildContext context, int index ){
                  double off = (100*(int.parse(inactive_data[index]["mrp"])-int.parse(inactive_data[index]["price"]))/int.parse(inactive_data[index]["mrp"]));
                  return inactive_data[index]['stock']=='1'?Card(
                    child: InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Detailed(inactive_data[index]["p_id"])));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 170,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Stack(
                                  children: <Widget>[
                                    Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(top:2.0),
                                      child: inactive_data[index]["img"]!=null?Image.network(inactive_data[index]["img"],fit: BoxFit.fill,
                                        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: SpinKitDualRing(
                                              color: Theme.of(context).accentColor,
                                              size: 20,
                                              lineWidth: 4,
                                            ),
                                          );
                                        },
                                        width: 120,
                                        height: 140,
                                      ):Image.asset("Images/no-img.png"),
                                    ),
                                    Container(
                                      child: Container(
                                          color: Colors.green,
                                          child: Padding(
                                              padding: const EdgeInsets.only(left:4.0,right: 4,top: 3,bottom: 3),
                                              child: Text((off.round()).toString()+"% off",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),)
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  padding: EdgeInsets.only(left:10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                int.parse(inactive_data[index]["price"].toString())>999?Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:10.0,top:2,bottom: 2,right: 10),
                                                    child: Text("FREE SHIPPING",style: TextStyle(fontSize: ScreenUtil().setSp(10),color: Colors.green,fontWeight: FontWeight.bold),),
                                                  ),
                                                ):Center(),
                                                Text(" "),
                                                off>10?Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:10.0,top:2,bottom: 2,right: 10),
                                                    child: Text("SPECIAL PRICE",style: TextStyle(fontSize: ScreenUtil().setSp(10),color: Colors.red,fontWeight: FontWeight.bold),),
                                                  ),
                                                ):Text(""),
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.start,
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: ScreenUtil().setWidth(ScreenUtil().setWidth(180)),
                                                child: Padding(
                                                  padding:EdgeInsets.only(top:5),
                                                  child: Text(inactive_data[index]["name"]!=null?inactive_data[index]["name"]:"Not Defined",overflow:TextOverflow.ellipsis ,maxLines: 1,style: TextStyle(fontWeight:FontWeight.bold,fontSize:17),),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenUtil().setWidth(180),
//                                                    color: Colors.red,
                                              child: Padding(
                                                padding:EdgeInsets.only(top:5),
                                                child: Text(
                                                    inactive_data[index]["description"]!=null?inactive_data[index]["description"].toString().trim():""
                                                    ,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:13)),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenUtil().setWidth(ScreenUtil().setWidth(180)),
                                              child: Padding(
                                                padding: EdgeInsets.only(top:5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text("\u20B9"+inactive_data[index]["price"],style: TextStyle(fontSize:ScreenUtil().setSp(18),color: Colors.green,fontWeight: FontWeight.bold,)),
                                                    ),
                                                    Text("  "),
                                                    Container(
                                                      child: Text(inactive_data[index]["mrp"]!=null?"\u20B9"+inactive_data[index]["mrp"]:"Not Defined",overflow: TextOverflow.ellipsis,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.black54,fontSize: ScreenUtil().setSp(14)),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              width: ScreenUtil().setWidth(180),
//                                                    color: Colors.red,
                                              child: Padding(
                                                padding:EdgeInsets.only(top:5),
                                                child: Text(
                                                    "*Available In Different colors" ,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:ScreenUtil().setSp(12),color: Colors.black54)),
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              width: ScreenUtil().setWidth(180),
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: inactive_data[index]['colors'].length,
                                                  itemBuilder: (BuildContext context,int indexx) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Container(
                                                        width: 15,height: 10,
                                                        decoration: BoxDecoration(
                                                          color: Color(int.parse("0xff"+inactive_data[index]['colors'][indexx]['color_code'])),
                                                          border: Border.all(
                                                            color: Constants.PRIMARY_COLOR,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ):Center();
                }):Center(child: Text("No data For this product!!"),),
      ),
    );
  }
}
