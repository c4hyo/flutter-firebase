import 'package:charity_with_happiness_firebase/firebase/auth/auth.dart';
import 'package:charity_with_happiness_firebase/screen/ui/auth/regis.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:charity_with_happiness_firebase/screen/widget/logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _email, _password;
  GlobalKey<FormState> _form = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: logoLogin(context),
                  ),
                  Text(
                    "Charity With Happiness",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "A routine social movement",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: Icon(Ionicons.ios_mail),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onSaved: (newValue) {
                        _email = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Format email salah";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Ionicons.ios_lock),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onSaved: (newValue) {
                        _password = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (_isLoading)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MaterialButton(
                          height: 60,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          minWidth: double.infinity,
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (_form.currentState.validate()) {
                              _form.currentState.save();
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await AuthServices.signIn(
                                  email: _email,
                                  password: _password,
                                );
                              } catch (e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Get.snackbar(
                                    "error", "Email atau Password salah");
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                  Divider(
                    height: 30,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Belum mempunyai akun? "),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            RegistrasiScreen(),
                            transition: Transition.noTransition,
                          );
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
