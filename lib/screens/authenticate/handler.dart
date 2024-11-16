import 'package:flutter/material.dart';
import 'package:umkmfirebase/screens/authenticate/login.dart';
import 'package:umkmfirebase/screens/authenticate/register.dart';


class Handler extends StatefulWidget {
  const Handler({super.key});

  @override
  State<Handler> createState() => _HandlerState();
}

class _HandlerState extends State<Handler> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn=!showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Login(toggleview: toggleView);
    }else{
      return Register(toggleview: toggleView);
    }
  }
}
