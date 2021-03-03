import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewers extends StatefulWidget {

  String name = "";
  String link = "";
  ImageViewers(this.name,this.link);

  @override
  _ImageViewersState createState() => _ImageViewersState();
}

class _ImageViewersState extends State<ImageViewers> {
  @override
  Widget build(BuildContext context) {
    print(PhotoViewComputedScale.covered.multiplier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name == "" ? "Image" : widget.name),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height/2,
          child: widget.link != "" ? Center(child: PhotoView(
            imageProvider: NetworkImage(widget.link),
            backgroundDecoration: BoxDecoration(color: Colors.white),
            // maxScale: 2.0,
            initialScale: PhotoViewComputedScale.covered*0.5,
          )) : Center(child: Text("No Image Available"),),
        ),
      ),
    );
  }
}
