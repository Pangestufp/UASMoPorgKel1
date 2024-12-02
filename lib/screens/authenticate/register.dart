import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      decoration: InputDecoration(hintText: 'Nama UMKM',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return 'Nama UMKM tidak boleh Kosong';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
    );

    final alamatUMKMField = TextFormField(
      controller: _alamatUMKM,
      decoration: InputDecoration(hintText: 'Alamat UMKM',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return 'Alamat UMKM tidak boleh Kosong';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
    );

    final emailField = TextFormField(
      controller: _email,
      decoration: InputDecoration(hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      autofocus: false,
      validator: (value) {
        if (value!.contains("@") && value!.endsWith(".com")) {
          return null;
        }
        return 'Email tidak sesuai';
      },
      style: TextStyle(color: Colors.white),
    );

    final passwordField = TextFormField(
      obscureText: _showHide,
      controller: _password,
      decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _showHide ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
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
      style: TextStyle(color: Colors.white),
    );

    final txBbutton = TextButton(
      onPressed: () {
        widget.toggleview!();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            "Kembali Login",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );


    final loginEmailPasswordButton = Material(
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
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
        child: Text(
          "Register",
          style: TextStyle(
              fontSize: 16, color: Colors.black),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A86B), Color(0xFF00A86B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/images/register.json",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  repeat: true,
                  reverse: true,
                ),
                Form(
                  key: _globalKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        namaUMKMField,
                        SizedBox(height: 20),
                        alamatUMKMField,
                        SizedBox(height: 20),
                        emailField,
                        SizedBox(height: 20),
                        passwordField,
                        SizedBox(height: 20),
                        loginEmailPasswordButton,
                        SizedBox(height: 10),
                        txBbutton,
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
