import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Column(
//       children: [
//         data1[0]['status_id'] == "3" ? GestureDetector(
//           onTap: (){
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 // return object of type Dialog
//                 return AlertDialog(
//                   title: new Text("Cancel Order?"),
//                   content: loadalert ? Container(
//                     child: Wrap(
//                       direction: Axis.vertical,
//                       children: <Widget>[
//                         SizedBox(
//                             width: 200,
//                             child: new Text(
//                               "Do you want to return Product?",
//                               maxLines: 3,)),
//                         Text(""),
//                         Row(
//                           children: <Widget>[
//                             Text("Total Amount: "),
//                             Text("\u20B9 " +
//                                 data1[0]['selling_price']
//                                     .toString(),
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18),)
//                           ],
//                         ),
//                       ],
//                     ),
//                   ) : ProgressDailog().Progress(context),
//                   actions: <Widget>[
//                     // usually buttons at the bottom of the dialog
//                     new FlatButton(
//                       child: new Text("No"),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     FlatButton(
//                       child: new Text("Yes"),
//                       onPressed: () {
//                         cancelOrder(data1[0]['order_id'].toString(), "4");
// //                                                Fluttertoast.showToast(msg: "Yes Order Delivered");
// //                                         if(data1[0]['status_id']==1){
// //                                           updateStatus(2, data1[0]['order_id']);
// //                                         }else if(data1[0]['status_id']=="2"){
// //                                           updateStatus(3, data1[0]['order_id']);
// //                                         }
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//                 border: Border.all(color: Colors.green)
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child:   Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text("\u20B9 " + data1[0]['selling_price'],
//                     style: TextStyle(color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold),),
//                   Container(
//                       decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.all(
//                               Radius.circular(12)),
//                           border: Border.all(color: Colors.green)
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(3.0),
//                         child: Row(
//                           children: <Widget>[
//                             Text("Return",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold),),
//                           ],
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         )
//             : data1[0]['status_id'] == "4" ? Container(
//           decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.all(Radius.circular(12)),
//               border: Border.all(color: Colors.red)
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text("\u20B9 " + data1[0]['selling_price'],
//                   style: TextStyle(color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold),),
//                 Container(
//                     decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.all(
//                             Radius.circular(12)),
//                         border: Border.all(color: Colors.red)
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Row(
//                         children: <Widget>[
//                           Text("Cancelled",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold),),
//                         ],
//                       ),
//                     )),
//               ],
//             ),
//           ),
//         )
//             : GestureDetector(
//           onTap: () {
//             loadalert ?  showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 // return object of type Dialog
//                 return AlertDialog(
//                   title: new Text("Cancel Order?"),
//                   content: loadalert ? Container(
//                     child: Wrap(
//                       direction: Axis.vertical,
//                       children: <Widget>[
//                         SizedBox(
//                             width: 200,
//                             child: new Text(
//                               "The order is confirmed to be delivered. Do you want to Cancel it?",
//                               maxLines: 3,)),
//                         Text(""),
//                         Row(
//                           children: <Widget>[
//                             Text("Total Amount: "),
//                             Text("\u20B9 " +
//                                 data1[0]['selling_price']
//                                     .toString(),
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18),)
//                           ],
//                         ),
//                       ],
//                     ),
//                   ) : ProgressDailog().Progress(context),
//                   actions: <Widget>[
//                     // usually buttons at the bottom of the dialog
//                     new FlatButton(
//                       child: new Text("No"),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     FlatButton(
//                       child: new Text("Yes"),
//                       onPressed: () {
//                         cancelOrder(data1[0]['order_id'].toString(), "4");
// //                                                Fluttertoast.showToast(msg: "Yes Order Delivered");
// //                                         if(data1[0]['status_id']==1){
// //                                           updateStatus(2, data1[0]['order_id']);
// //                                         }else if(data1[0]['status_id']=="2"){
// //                                           updateStatus(3, data1[0]['order_id']);
// //                                         }
//                       },
//                     ),
//                   ],
//                 );
//               },
//             ):Center();
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text("\u20B9 " + data1[0]['selling_price'],
//                 style: TextStyle(color: Colors.green,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold),),
//               Container(
//                   decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.all(
//                           Radius.circular(12)),
//                       border: Border.all(color: Colors.red)
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: Row(
//                       children: <Widget>[
//                         Text(data1[0]['status_id']=="1"?"Cancel Order":data1[0]['status_id']=="2"?"Cancel Order":"",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold),),
//                         Icon(Icons.arrow_forward_ios,
//                           color: Colors.white,),
//                       ],
//                     ),
//                   )),
//             ],
//           ),
//         ),
//       ],
    );
  }
}
