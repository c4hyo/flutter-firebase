import 'dart:io';

import 'package:charity_with_happiness_firebase/firebase/collection/user_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilEditScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;

  ProfilEditScreen({this.profil, this.user});
  @override
  _ProfilEditScreenState createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<ProfilEditScreen> {
  File _fotoProfil;
  User users;
  bool isLoading = false;
  String _nama, _telepon, _alamat, _pekerjaan, _tempatLahir, _tanggalLahir;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();

  _pickImage() async {
    final images = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _fotoProfil = File(images.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (_form.currentState.validate()) {
                _form.currentState.save();
                setState(() {
                  isLoading = true;
                });
                String _fotoProfils = "";
                if (_fotoProfil == null) {
                  _fotoProfils = null;
                } else {
                  _fotoProfils = await StorageServices.uploadsImage(
                    fileImage: _fotoProfil,
                    tipe: "user",
                  );
                }
                ProfilModel model = ProfilModel(
                  alamat: _alamat,
                  pekerjaan: _pekerjaan,
                  tanggalLahir: _tanggalLahir,
                  telepon: _telepon,
                  tempatLahir: _tempatLahir,
                  nama: _nama,
                  fotoProfil: _fotoProfils,
                );
                await UserDatabase.updateProfil(
                  widget.user,
                  model: model,
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (isLoading)
                  ? LinearProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor,
                      ),
                    )
                  : SizedBox.shrink(),
              Container(
                height: 250,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: (_fotoProfil == null)
                            ? GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 80,
                                  child: Icon(Icons.person_add),
                                ),
                              )
                            : GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: FileImage(_fotoProfil),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _form,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.profil.nama,
                        onSaved: (newValue) {
                          _nama = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Nama",
                        ),
                      ),
                      Divider(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        initialValue: widget.profil.telepon,
                        onSaved: (newValue) {
                          _telepon = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Nomor Telepon",
                        ),
                      ),
                      Divider(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: widget.profil.alamat,
                        onSaved: (newValue) {
                          _alamat = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Alamat",
                        ),
                      ),
                      Divider(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: widget.profil.pekerjaan,
                        onSaved: (newValue) {
                          _pekerjaan = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Pekerjaan",
                        ),
                      ),
                      Divider(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: widget.profil.tempatLahir,
                        onSaved: (newValue) {
                          _tempatLahir = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Tempat Lahir",
                        ),
                      ),
                      Divider(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: widget.profil.tanggalLahir,
                        onSaved: (newValue) {
                          _tanggalLahir = newValue;
                        },
                        decoration: InputDecoration(
                          labelText: "Tanggal Lahir",
                        ),
                      ),
                      Divider(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
