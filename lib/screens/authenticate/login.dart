import 'package:flutter/material.dart';
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
        child: Text("Belum terdaftar"));

    final loginEmailPasswordButton = Material(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        child: Text("Sign In Email"),
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
