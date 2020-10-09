import 'package:charity_with_happiness_firebase/firebase/collection/berita_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/berita/berita_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeritaDetailScreen extends StatefulWidget {
  final User user;
  final String idBerita;
  final BeritaModel berita;
  final bool isAdmin;

  BeritaDetailScreen({this.user, this.berita, this.idBerita, this.isAdmin});
  @override
  _BeritaDetailScreenState createState() => _BeritaDetailScreenState();
}

class _BeritaDetailScreenState extends State<BeritaDetailScreen> {
  bool _isLoading = false;
  _delete({String url}) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Hapus Berita"),
          children: [
            SimpleDialogOption(
              child: Text("Hapus"),
              onPressed: () async {
                if (url != "") {
                  await StorageServices.deleteImage(imageUrl: url);
                }
                await BeritaDatabase.deleteBerita(id: widget.idBerita);

                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text("Batal"),
              onPressed: () {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (_isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: BeritaDatabase.berita.doc(widget.idBerita).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  DocumentSnapshot datas = snapshot.data;
                  BeritaModel model = BeritaModel.maps(datas);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * (1 / 3),
                          width: double.infinity,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: (model.thumbnail == "")
                                      ? Icon(
                                          Icons.broken_image,
                                          color: Theme.of(context).primaryColor,
                                          size: 80,
                                        )
                                      : Image(
                                          image: NetworkImage(model.thumbnail),
                                        ),
                                ),
                              ),
                              Positioned.fill(
                                top: 10,
                                left: 10,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () => Get.back(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      child: Icon(Icons.arrow_back_ios,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: widget.isAdmin
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Get.to(
                                            BeritaUpdateScreen(
                                              berita: model,
                                              idBerita: widget.idBerita,
                                              user: widget.user,
                                            ),
                                            transition: Transition.fade);
                                      },
                                      child: Text("Update"),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _delete(url: model.thumbnail);
                                      },
                                      child: Text("Hapus"),
                                    )
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        ListTile(
                          title: Text(model.judul),
                          subtitle: Text(
                            DateTimeFormat.format(
                              DateTime.parse(model.waktuPosting),
                              format: DateTimeFormats.european,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text("Keterangan: "),
                          subtitle: Text(model.deskripsi),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
