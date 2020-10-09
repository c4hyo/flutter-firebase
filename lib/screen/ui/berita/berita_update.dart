import 'dart:io';

import 'package:charity_with_happiness_firebase/firebase/collection/berita_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BeritaUpdateScreen extends StatefulWidget {
  final String idBerita;
  final BeritaModel berita;
  final User user;

  BeritaUpdateScreen({this.berita, this.idBerita, this.user});
  @override
  _BeritaUpdateScreenState createState() => _BeritaUpdateScreenState();
}

class _BeritaUpdateScreenState extends State<BeritaUpdateScreen> {
  bool _isLoading = false;
  GlobalKey<FormState> _form = new GlobalKey<FormState>();
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
                          ? (widget.berita.thumbnail == "")
                              ? Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Image(
                                  image: NetworkImage(widget.berita.thumbnail),
                                )
                          : Image(
                              image: FileImage(_thumbnail),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("Judul"),
                      subtitle: TextFormField(
                        initialValue: widget.berita.judul,
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
                        initialValue: widget.berita.deskripsi,
                        maxLines: null,
                        onSaved: (newValue) {
                          _deskripsi = newValue;
                        },
                        keyboardType: TextInputType.multiline,
                      ),
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
                        if (_urlThumbnail == null) {
                          _urlThumbnail = widget.berita.thumbnail;
                        } else {
                          if (widget.berita.thumbnail != "") {
                            await StorageServices.deleteImage(
                                imageUrl: widget.berita.thumbnail);
                          }
                          _urlThumbnail = await StorageServices.uploadsImage(
                              fileImage: _thumbnail, tipe: "berita");
                        }
                        BeritaModel model = BeritaModel(
                          judul: _judul,
                          deskripsi: _deskripsi,
                          waktuPosting: DateTime.now().toString(),
                          thumbnail: _urlThumbnail,
                        );
                        await BeritaDatabase.updateBerita(
                          id: widget.idBerita,
                          beritaModel: model,
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
