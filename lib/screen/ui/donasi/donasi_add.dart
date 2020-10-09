import 'dart:io';

import 'package:charity_with_happiness_firebase/firebase/collection/donasi_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DonasiAddScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  DonasiAddScreen({this.user, this.profil});
  @override
  _DonasiAddScreenState createState() => _DonasiAddScreenState();
}

class _DonasiAddScreenState extends State<DonasiAddScreen> {
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _judul, _deskripsi, _infoDonasi, _nominalDonasi, _tanggalDonasi;
  String _kategori = "Pilih Kategori";
  File _thumbnail;
  ImagePicker _picker = ImagePicker();

  _pickImage() async {
    final images = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _thumbnail = File(images.path);
    });
  }

  _datePick() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (date != null) {
      setState(() {
        _tanggalDonasi = date.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Tambah Donasi"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              setState(() {
                _isLoading = !_isLoading;
              });
              if (_form.currentState.validate()) {
                _form.currentState.save();
                String _urlThumbnail = "";
                if (_thumbnail == null) {
                  _urlThumbnail = null;
                } else {
                  _urlThumbnail = await StorageServices.uploadsImage(
                    fileImage: _thumbnail,
                    tipe: "donasi",
                  );
                }
                DonasiModel model = DonasiModel(
                  judul: _judul,
                  deskripsi: _deskripsi,
                  infoDonasi: _infoDonasi,
                  jenis: _kategori,
                  nominalDonasi: _nominalDonasi,
                  tanggalDonasi: _tanggalDonasi,
                  waktuPosting: DateTime.now().toString(),
                  thumbnail: _urlThumbnail,
                );
                await DonasiDatabase.addDonasi(
                  d: model,
                  user: widget.user,
                );

                Get.back();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (_isLoading) ? LinearProgressIndicator() : SizedBox.shrink(),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: MediaQuery.of(context).size.height * (1 / 3),
                      width: double.infinity,
                      color: Colors.white,
                      child: (_thumbnail == null)
                          ? Center(
                              child: Icon(
                                Icons.image,
                                size: 70,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : Image(
                              image: FileImage(_thumbnail),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Judul"),
                      subtitle: TextFormField(
                        onSaved: (newValue) {
                          _judul = newValue;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Informasi Donasi"),
                      subtitle: TextFormField(
                        maxLength: null,
                        keyboardType: TextInputType.multiline,
                        onSaved: (newValue) {
                          _infoDonasi = newValue;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Nominal Donasi"),
                      subtitle: TextFormField(
                        decoration: InputDecoration(
                          // prefixIcon: Text("Rp. "),
                          prefix: Text("Rp.  "),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) {
                          _nominalDonasi = newValue;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Tanggal penutupan donasi"),
                      subtitle:
                          Text((_tanggalDonasi == null) ? "" : _tanggalDonasi),
                      trailing: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: _datePick,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Kategori"),
                      subtitle: DropdownButton<String>(
                        value: _kategori,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            if (newValue == "Pilih Kategori") {
                              _kategori = "Lain-lain";
                            } else {
                              _kategori = newValue;
                            }
                          });
                        },
                        items: <String>[
                          'Bencana',
                          'Pendidikan',
                          'Lain-lain',
                          'Pilih Kategori'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Deskripsi"),
                      subtitle: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onSaved: (newValue) {
                          _deskripsi = newValue;
                        },
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
