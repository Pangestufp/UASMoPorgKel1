import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umkmfirebase/services/auth.dart';

class Login extends StatefulWidget {
  final Function? toggleview;
  const Login({super.key, this.toggleview});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showHide = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Email',
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
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        return null;
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
        focusedErrorBorder: OutlineInputBorder(
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
        ),
      ),
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
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
          Text(
            "Belum terdaftar?",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 2),
          Icon(
            Icons.navigate_next,
            color: Colors.white,
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
            dynamic result = await _authService.signInEmailPassword(
                _email.text, _password.text);
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
          "Sign In Email",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        color: Colors.white,
      ),
    );


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A86B), Color(0xFF00A86B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/images/login.json",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              repeat: true,
              reverse: true,
            ),
            SizedBox(height: 20),
            Form(
              key: _globalKey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 40),
                    loginEmailPasswordButton,
                    SizedBox(height: 20),
                    txBbutton,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
