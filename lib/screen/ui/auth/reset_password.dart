import 'package:charity_with_happiness_firebase/firebase/auth/auth.dart';
import 'package:charity_with_happiness_firebase/screen/widget/logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isLoading = false;
  String _email;
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
                                await AuthServices.auth
                                    .sendPasswordResetEmail(email: _email);
                                Get.back();
                              } catch (e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Get.snackbar("error", "Cek email anda");
                              }
                            }
                          },
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
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
