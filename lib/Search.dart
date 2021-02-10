import 'dart:convert';
import 'package:dproject/searchDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Constants.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
class _SearchState extends State<Search> {
  bool data=false;
var responsed;
void search(String word)async{
  setState(() {
    data = true;
  });
  final http.Response response = await http.post(
    API.search1,
      headers: <String, String>{
        'Content_Type': 'application/json; charset=UTF-8'
      },
      body: {
        'authkey' : API.key,
        'name':word,
      });
  print(response.body);
  setState(() {
    data = false;
    if(response.statusCode==200){
    var res = json.decode(response.body);
    responsed = res;
    if(res['status']!=2){
      responsed = null;
      Fluttertoast.showToast(msg: "Nothing Found!!!");
    }
  }
  });

}
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 780, allowFontScaling: false);
    final height = MediaQuery.of(context).size.height/780;
    final width= MediaQuery.of(context).size.width/360;
    var viewportConstraints;
    double off =0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        elevation: 0.0,
      ),
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Container(
                      height:45,
                      width: MediaQuery.of(context).size.width-ScreenUtil().setWidth(30),
                      color: Theme.of(context).accentColor,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              autofocus: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search,color: Theme.of(context).primaryColor,),
                                    hintText: "Search Products ....",
                                    filled: true,
                                    fillColor: Theme.of(context).accentColor),
                                onChanged:(input){
                                  search(input);
                                  print(input);
                                }
                            ),
                          ),
                          data ? Container(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                child: SpinKitRing(
                                  size: 30,
                                  lineWidth: 3,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ): Center(),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: responsed!=null ? ListView.builder(
                      itemCount: responsed['result'].length,
                      itemBuilder: (BuildContext context, int index ){
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            Fluttertoast.showToast(msg: responsed["result"][index]["name"]);
                            Navigator.push(context,MaterialPageRoute(builder : (context)=>Searchde(responsed['result'][index]['name'])));
                        },
                          child: Container(
                            width:MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(responsed['result'][index]['name'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                    );
                  }) : Center(),
                ),
              ]),
    );
  }
}


