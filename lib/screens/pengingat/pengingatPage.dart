import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/pengingat.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class PengingatPage extends StatefulWidget {
  final UserModel user;
  PengingatPage({super.key, required this.user});

  @override
  State<PengingatPage> createState() => _PengingatPageState();
}

class _PengingatPageState extends State<PengingatPage> {
  List<Pengingat> _pengingatList = [];

  @override
  void initState() {
    super.initState();
    _fetchPengingatList();
  }

  Future<void> _fetchPengingatList() async {
    _pengingatList = await AppServices.readAllPengingat(widget.user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Center(
          child: Text(
            "Pengingat",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: _pengingatList.length,
        itemBuilder: (context, index) {
          final pengingat = _pengingatList[index];
          return ListTile(
            title: Text("Pengingat - ${index + 1}"),
            subtitle: Text(pengingat.isi),
            leading: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.d().format(DateTime.parse(pengingat.tanggal)),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.blue),
                ),
                Text(DateFormat.MMM().format(DateTime.parse(pengingat.tanggal))),
              ],
            ),
          );
        },
      ),
    );
  }
}