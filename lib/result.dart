
import 'package:beemy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ResultCalculator extends StatelessWidget {
    final double weight;
  final String weightUnit;
  final double height;
  final String heightUnit;

  ResultCalculator(
      {@required this.weight,
      @required this.weightUnit,
      @required this.height,
      @required this.heightUnit});
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
           backgroundColor: Colors.white,
           leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/back.png", 
              fit: BoxFit.fill,)
            ),
            Center(
              child:BeemyResult(
                  weight:weight,
                  weightUnit: weightUnit,
                  height: height,
                  heightUnit: heightUnit),
            ),


          ],
        ),
        );
  }
}
