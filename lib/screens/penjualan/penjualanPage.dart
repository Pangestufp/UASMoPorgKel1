import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';

class PenjualanPage extends StatefulWidget {
  final UserModel user;
  PenjualanPage({super.key, required this.user});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
