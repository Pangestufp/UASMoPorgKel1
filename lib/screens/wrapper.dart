import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/screens/authenticate/handler.dart';
import 'package:umkmfirebase/screens/nav/bottomNav.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser?>(context);

    if(user == null){
      return Handler();
    }else{
      return BottomNav(firebaseUser: user,);
    }
  }
}
