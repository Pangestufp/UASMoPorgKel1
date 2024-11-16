import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';

class KeuanganPage extends StatefulWidget {
  final UserModel user;
  KeuanganPage({super.key,required this.user});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

        ],
      ),
    );
  }
}
