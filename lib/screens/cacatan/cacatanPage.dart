import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';

class CacatanPage extends StatefulWidget {
  final UserModel user;
  CacatanPage({super.key, required this.user});

  @override
  State<CacatanPage> createState() => _CacatanPageState();
}

class _CacatanPageState extends State<CacatanPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
