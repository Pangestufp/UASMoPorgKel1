import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/userModel.dart';

class Pengaturan extends StatefulWidget {
  final UserModel user;
  Pengaturan({super.key,required this.user});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
      ),
    );
  }
}
