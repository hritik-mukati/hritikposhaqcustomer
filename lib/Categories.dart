import 'package:dproject/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

  class Categories extends StatefulWidget {
    @override
    _CategoriesState createState() => _CategoriesState();
  }

  class _CategoriesState extends State<Categories> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 30,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: Icon(Icons.notifications_none,color: Constants.PRIMARY_COLOR,),
                            onPressed: (){
                              Fluttertoast.showToast(msg: "Notification..");
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 35,
                            color: Colors.white12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:  CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.search,color:Colors.grey),
                                Text(" Search",style: TextStyle(color:Colors.grey,fontSize: 17),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: Icon(Icons.redeem,color: Constants.PRIMARY_COLOR,),
                            onPressed: (){
                              Fluttertoast.showToast(msg: "Cart..");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: ListView.builder(
                    itemCount: 12,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return Padding(
                        padding:EdgeInsets.only(left:15.0,top: 2,bottom: 2,right: 5),
                        child: Container(
//                          height:40,
                          child: Center(child: Text("WOMEN",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
                        ),
                      );
                    }),
              ),
//              color: Colors.yellow,
            ),
            Expanded(
              child:Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,bottom: 5,left: 8,right: 3),
                      child: Container(
//                         color: Colors.grey,
                        child: ListView.builder(
                            itemCount: 12,
//                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return Padding(
                                padding:EdgeInsets.only(left:8.0,top: 1,bottom: 22,right: 5),
                                child: Container(
                                  child: Text("New Indian",style: TextStyle(fontSize: 17),),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Color(0xffF5F5F5),
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context , index){
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Text(" Tops "),
                                Container(
                                  height: 200,
                                  child: Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(7, (index) {
                                        return Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image.asset("images/google_logo.png"),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          );
                        }),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      );
    }
  }
