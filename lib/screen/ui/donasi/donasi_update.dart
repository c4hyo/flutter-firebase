import 'dart:io';

import 'package:charity_with_happiness_firebase/firebase/collection/donasi_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DonasiUpdateScreen extends StatefulWidget {
  final User user;
  final String idDonasi;
  final DonasiModel donasi;

  DonasiUpdateScreen({this.user, this.idDonasi, this.donasi});
  @override
  _DonasiUpdateScreenState createState() => _DonasiUpdateScreenState();
}

class _DonasiUpdateScreenState extends State<DonasiUpdateScreen> {
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _judul, _deskripsi, _infoDonasi, _nominalDonasi, _tanggalDonasi;
  String _kategori;
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
  void initState() {
    super.initState();
    _kategori = widget.donasi.jenis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          ? (widget.donasi.thumbnail == "")
                              ? Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Image(
                                  image: NetworkImage(widget.donasi.thumbnail),
                                )
                          : Image(
                              image: FileImage(_thumbnail),
                            ),
                    ),
                  ),
                  ListTile(
                    title: Text("Judul"),
                    subtitle: TextFormField(
                      initialValue: widget.donasi.judul,
                      onSaved: (newValue) {
                        _judul = newValue;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Informasi Donasi"),
                    subtitle: TextFormField(
                      initialValue: widget.donasi.infoDonasi,
                      onSaved: (newValue) {
                        _infoDonasi = newValue;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Nominal Donasi"),
                    subtitle: TextFormField(
                      initialValue: widget.donasi.nominalDonasi,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _nominalDonasi = newValue;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Tanggal penutupan donasi"),
                    subtitle: Text((_tanggalDonasi == null)
                        ? "${widget.donasi.tanggalDonasi}"
                        : _tanggalDonasi),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: _datePick,
                    ),
                  ),
                  ListTile(
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
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  ListTile(
                    title: Text("Deskripsi"),
                    subtitle: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      initialValue: widget.donasi.deskripsi,
                      onSaved: (newValue) {
                        _deskripsi = newValue;
                      },
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                      if (_form.currentState.validate()) {
                        _form.currentState.save();
                        String _urlThumbnail = "";
                        if (_thumbnail == null) {
                          _urlThumbnail = widget.donasi.thumbnail;
                        } else {
                          if (widget.donasi.thumbnail != "") {
                            await StorageServices.deleteImage(
                                imageUrl: widget.donasi.thumbnail);
                          }
                          _urlThumbnail = await StorageServices.uploadsImage(
                              fileImage: _thumbnail, tipe: "berita");
                        }

                        DonasiModel model = DonasiModel(
                          judul: _judul,
                          deskripsi: _deskripsi,
                          infoDonasi: _infoDonasi,
                          jenis: _kategori,
                          nominalDonasi: _nominalDonasi,
                          tanggalDonasi: (_tanggalDonasi == null)
                              ? widget.donasi.tanggalDonasi
                              : _tanggalDonasi,
                          thumbnail: _urlThumbnail,
                        );
                        await DonasiDatabase.updateDonasi(
                          id: widget.idDonasi,
                          d: model,
                        );
                        Get.back();
                      }
                    },
                    child: Text("Update"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
