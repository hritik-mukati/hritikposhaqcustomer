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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                widget.status>0 ? CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ):CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 20,
                  child: CircleAvatar(
                    child: Icon(Icons.help,color: Theme.of(context).accentColor,size: 30,),
                    backgroundColor: Colors.white,
                    radius: 18,
                  ),
                ),
                widget.status>0 ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.green,
                    ),
                  ),
                ):Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
                widget.status > 1 ? Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 20,
                      child: CircleAvatar(
                        child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                        backgroundColor: Colors.white,
                        radius: 18,
                      ),
                    )
                ):Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child:CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 20,
                      child: CircleAvatar(
                        child: Icon(Icons.help,color: Theme.of(context).accentColor,size: 30,),
                        backgroundColor: Colors.white,
                        radius: 18,
                      ),
                    )
                ),
                widget.status>1 ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.green,
                    ),
                  ),
                ):Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),),
                widget.status > 2 ? widget.status == 4 ? Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 20,
                      child: CircleAvatar(
                        child: Icon(Icons.check_circle,color: Colors.red,size: 30,),
                        backgroundColor: Colors.white,
                        radius: 18,
                      ),
                    )
                ): Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 20,
                      child: CircleAvatar(
                        child: Icon(Icons.check_circle,color: Colors.green,size: 30,),
                        backgroundColor: Colors.white,
                        radius: 18,
                      ),
                    )
                ):Padding(
                    padding: const EdgeInsets.fromLTRB(3,0,3,0),
                    child:CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 20,
                      child: CircleAvatar(
                        child: Icon(Icons.help,color: Theme.of(context).accentColor,size: 30,),
                        backgroundColor: Colors.white,
                        radius: 18,
                      ),
                    )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Order Placed"),
                Expanded(child: Text(""),),
                Text("Dispatched"),
                Expanded(child: Text(" "),),
                widget.status>2 ? widget.status == 4 ? Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Cancelled"),
                ):Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Delivered"),
                ):Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Delivered"),
                ),],
            ),
          )
        ],
      ),
    );
  }
}
