import 'package:flutter/material.dart';
import 'package:umkmfirebase/services/auth.dart';

class Register extends StatefulWidget {
  final Function? toggleview;
  const Register({super.key, this.toggleview});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _showHide = true;
  final _email = TextEditingController();
  final _namaUMKM = TextEditingController();
  final _alamatUMKM = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final namaUMKMField = TextFormField(
      controller: _namaUMKM,
      decoration: InputDecoration(hintText: 'Nama UMKM'),
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return 'Nama UMKM tidak boleh Kosong';
        }
        return null;
      },
    );

    final alamatUMKMField = TextFormField(
      controller: _alamatUMKM,
      decoration: InputDecoration(hintText: 'Alamat UMKM'),
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return 'Alamat UMKM tidak boleh Kosong';
        }
        return null;
      },
    );

    final emailField = TextFormField(
      controller: _email,
      decoration: InputDecoration(hintText: 'Email'),
      autofocus: false,
      validator: (value) {
        if (value!.contains("@") && value!.endsWith(".com")) {
          return null;
        }
        return 'Email tidak sesuai';
      },
    );

    final passwordField = TextFormField(
      obscureText: _showHide,
      controller: _password,
      decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(
              _showHide ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _showHide = !_showHide;
              });
            },
          )),
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return 'Password tidak boleh Kosong';
        }
        return null;
      },
    );

    final txBbutton = TextButton(
        onPressed: () {
          widget.toggleview!();
        },
        child: Text("Kembali Login"));

    final loginEmailPasswordButton = Material(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () async {
          if (_globalKey.currentState!.validate()) {
            dynamic result = await _authService.registerWithEmailPassword(
                _email.text, _password.text, _namaUMKM.text, _alamatUMKM.text);
            if (result.uid == null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
          }
        },
        child: Text("Register"),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _globalKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  namaUMKMField,
                  SizedBox(
                    height: 20,
                  ),
                  alamatUMKMField,
                  SizedBox(
                    height: 20,
                  ),
                  emailField,
                  SizedBox(
                    height: 20,
                  ),
                  passwordField,
                  SizedBox(
                    height: 20,
                  ),
                  txBbutton,
                  SizedBox(
                    height: 20,
                  ),
                  loginEmailPasswordButton,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
