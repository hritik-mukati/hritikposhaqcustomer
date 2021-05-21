import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Line extends StatefulWidget {

  int status = 0;


  Line(this.status);

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.status == 1?Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
              ],
            )
                :widget.status == 2?Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
                CircleAvatar(
                  radius:20,
                  backgroundColor: Colors.white,
                )
              ],
            )
                :widget.status == 3?Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
              ],
            )
                :widget.status == 4?Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.red,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.red,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.red,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.red,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.red,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
              ],
            )
                :widget.status > 4?Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.black26,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.black26,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.black26,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.black26,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.black26,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.black26,
                    ),
                  ),),
                CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.black26,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
              ],
            )
                :Center(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Order Placed",overflow: TextOverflow.ellipsis,),
                Expanded(child: Text(""),),
                Text("Dispatched",overflow: TextOverflow.ellipsis,),
                Expanded(child: Text(" "),),
                 widget.status == 4? Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Cancelled",overflow: TextOverflow.ellipsis,),
                )
                    :Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Delivered",overflow: TextOverflow.ellipsis,),
                ),
                widget.status<=4?Center():Expanded(child: Text(" "),),
                widget.status<=4?Center():widget.status ==5? Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Return",overflow: TextOverflow.ellipsis,),
                )
                :Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Returned",overflow: TextOverflow.ellipsis,),
                )
                ,],
            ),
          )
        ],
      ),
    );
  }
}
