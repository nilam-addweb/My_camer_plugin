import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  String id = DateTime.now().toIso8601String();
  runApp(MaterialApp(home: MyApp(id: id)));
}

class MyApp extends StatefulWidget {
  final String id;

  const MyApp({Key key, this.id}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Stack(
          children: [

Text("helloo")

          ],
        ),
      ),


    );
  }





}