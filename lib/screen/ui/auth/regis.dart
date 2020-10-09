import 'package:charity_with_happiness_firebase/firebase/auth/auth.dart';
import 'package:charity_with_happiness_firebase/screen/widget/logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class RegistrasiScreen extends StatefulWidget {
  @override
  _RegistrasiScreenState createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  String _email, _password, _name;
  bool _isLoading = false;
  GlobalKey<FormState> _form = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                      onSaved: (newValue) {
                        _name = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Nama tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        prefixIcon: Icon(Ionicons.ios_person),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
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
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: Icon(Ionicons.ios_mail),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      obscureText: true,
                      onSaved: (newValue) {
                        _password = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        _form.currentState.save();
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Masukan Password",
                        prefixIcon: Icon(Ionicons.ios_lock),
                        suffixIcon: Icon(Ionicons.ios_eye_off),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Konfirmasi password tidak boleh kosong";
                        }
                        if (value != _password) {
                          return "Password tidak sama";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Masukan Password Kembali",
                          prefixIcon: Icon(Ionicons.ios_lock),
                          suffixIcon: Icon(Ionicons.ios_eye_off),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          errorBorder: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: (_isLoading)
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
                              _form.currentState.save();
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await AuthServices.signUp(
                                  email: _email,
                                  password: _password,
                                  nama: _name,
                                );
                                Get.back();
                              } catch (e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Get.snackbar("Error", "Ada kesalahan");
                              }
                            },
                            child: Text(
                              "Buat Akun",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Sudah memiliki akun? "),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
