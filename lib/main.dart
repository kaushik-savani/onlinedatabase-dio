import 'package:flutter/material.dart';
import 'package:onlinedatabase/insertpage.dart';
import 'package:onlinedatabase/viewpage.dart';

void main(){
  runApp(MaterialApp(home: viewpage(),));
}

class online extends StatefulWidget {
  const online({Key? key}) : super(key: key);

  @override
  State<online> createState() => _onlineState();
}

class _onlineState extends State<online> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
