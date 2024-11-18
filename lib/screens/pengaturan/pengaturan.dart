import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/wrapper.dart';
import 'package:umkmfirebase/services/appServices.dart';

class Pengaturan extends StatefulWidget {
  final UserModel user;
  Pengaturan({super.key, required this.user});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final TextEditingController _namaUMKMController = new TextEditingController();
  final TextEditingController _alamatUMKMController =
      new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _namaUMKMController.text = widget.user.namaUMKM;
    _alamatUMKMController.text = widget.user.alamatUMKM;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Pengaturan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Nama UMKM",
                  labelStyle: TextStyle(color: Colors.teal[700]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  )),
              controller: _namaUMKMController,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Alamat UMKM",
                  labelStyle: TextStyle(color: Colors.teal[700]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  )),
              controller: _alamatUMKMController,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      AppServices.updateUser(UserModel(uid: widget.user.uid, namaUMKM: _namaUMKMController.text, alamatUMKM: _alamatUMKMController.text));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Wrapper()),
                            (route) => false,
                      );

                    },
                    child: Text(
                      "Ubah",
                      style: TextStyle(color: Colors.teal[700]),
                    )))
          ],
        ),
      ),
    );
  }
}
