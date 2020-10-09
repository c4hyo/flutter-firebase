import 'dart:io';

import 'package:charity_with_happiness_firebase/firebase/collection/berita_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BeritaAddScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;

  BeritaAddScreen({this.profil, this.user});
  @override
  _BeritaAddScreenState createState() => _BeritaAddScreenState();
}

class _BeritaAddScreenState extends State<BeritaAddScreen> {
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _judul, _deskripsi;
  File _thumbnail;
  ImagePicker _picker = ImagePicker();

  _pickImage() async {
    final images = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _thumbnail = File(images.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Tambah Berita"),
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
                    tipe: "berita",
                  );
                }
                BeritaModel model = BeritaModel(
                  judul: _judul,
                  deskripsi: _deskripsi,
                  waktuPosting: DateTime.now().toString(),
                  thumbnail: _urlThumbnail,
                );
                await BeritaDatabase.addBerita(
                  beritaModel: model,
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
                      title: Text("Deskripsi"),
                      subtitle: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onSaved: (newValue) {
                          _deskripsi = newValue;
                        },
                      ),
                    ),
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
