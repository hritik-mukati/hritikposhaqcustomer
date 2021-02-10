import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Constants.dart';

class ProgressDailog{
  Widget Progress(context){
    return Center(
      child: Container(
//        color: Colors.white,
        width: 100,
        height: 100,
          child: SpinKitRipple(
            color: Constants.PRIMARY_COLOR,
            size: 60,
          ),
      ),
    );
  }
}