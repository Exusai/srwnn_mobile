import 'package:flutter/material.dart';
import 'enter.dart';
import 'register.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showSingIn = false;
  void toggleView(){
    setState(() => showSingIn = !showSingIn);
  }
  @override
  Widget build(BuildContext context) {
    if (showSingIn == true){
      return SingIn(toggleView: toggleView);
    }else{
      return Register(toggleView: toggleView);
    }
  }
}