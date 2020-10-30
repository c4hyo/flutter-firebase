import 'dart:io';

import 'package:charity_with_happiness_firebase/firebase/collection/donasi_db.dart';
import 'package:charity_with_happiness_firebase/firebase/storage/image_storage.dart';
import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/other/text.dart';
import 'package:charity_with_happiness_firebase/screen/ui/donasi/donasi_update.dart';
import 'package:charity_with_happiness_firebase/screen/ui/donasi/riwayat_donasi_all.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DonasiDetailScreen extends StatefulWidget {
  final DonasiModel donasi;
  final User user;
  final ProfilModel profil;
  final String idDonasi;
  final bool isAdmin;
  DonasiDetailScreen(
      {this.donasi, this.profil, this.user, this.idDonasi, this.isAdmin});
  @override
  _DonasiDetailScreenState createState() => _DonasiDetailScreenState();
}

class _DonasiDetailScreenState extends State<DonasiDetailScreen> {
  bool _isLoading = false;
  String _nominalDonasi;
  ImagePicker _picker = ImagePicker();
  File _buktiDonasi;
  int total = 0;

  GlobalKey<FormState> _donasiKey = GlobalKey<FormState>();
  _delete({String url}) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Hapus Donasi"),
          children: [
            SimpleDialogOption(
              child: Text("Hapus"),
              onPressed: () async {
                if (url != "") {
                  await StorageServices.deleteImage(imageUrl: url);
                }
                await DonasiDatabase.deleteDonasi(id: widget.idDonasi);

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

  _pickImage() async {
    final images = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _buktiDonasi = File(images.path);
    });
  }

  _donasi() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Donasi Sekarang"),
          children: [
            Form(
              key: _donasiKey,
              child: Column(
                children: [
                  SimpleDialogOption(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _nominalDonasi = newValue;
                      },
                      decoration: InputDecoration(
                        hintText: "Nominal Donasi",
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Upload bukti transfer donasi"),
                        ),
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    child: RaisedButton(
                      child: Text("Donasi Sekarang"),
                      onPressed: () async {
                        if (_donasiKey.currentState.validate()) {
                          _donasiKey.currentState.save();
                          int _banyakDonasi;
                          String _dons = "";
                          if (_buktiDonasi == null) {
                            _dons = null;
                          } else {
                            _dons = await StorageServices.uploadsImage(
                              fileImage: _buktiDonasi,
                              tipe: "bukti_donasi",
                            );
                          }
                          final _cek = await DonasiDatabase.donasi
                              .doc(widget.idDonasi)
                              .collection("donatur")
                              .doc(widget.user.uid)
                              .get();
                          if (_cek.exists) {
                            Map<String, dynamic> _getNominal = _cek.data();
                            _banyakDonasi = (int.parse(_nominalDonasi) +
                                _getNominal['nominal_donasi']);
                          } else {
                            _banyakDonasi = int.parse(_nominalDonasi);
                          }
                          await DonasiDatabase.aksiDonasi(
                            buktiDonasi: _dons,
                            idDonasi: widget.idDonasi,
                            idUser: widget.user.uid,
                            nama: widget.profil.nama,
                            nominal: _banyakDonasi,
                          );
                          Get.back();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("$total");
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
                stream: DonasiDatabase.donasi.doc(widget.idDonasi).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  DocumentSnapshot datas = snapshot.data;
                  DonasiModel model = DonasiModel.maps(datas);
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
                        (widget.isAdmin)
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Get.to(
                                          DonasiUpdateScreen(
                                            donasi: model,
                                            idDonasi: widget.idDonasi,
                                            user: widget.user,
                                          ),
                                        );
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
                                ),
                              )
                            : SizedBox.shrink(),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        ListTile(
                          title: Text("${model.judul} (${model.jenis})"),
                          subtitle: Text(
                            DateTimeFormat.format(
                              DateTime.parse(model.waktuPosting),
                              format: DateTimeFormats.european,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text("Informasi Donasi: "),
                          subtitle: Text(model.infoDonasi),
                        ),
                        ListTile(
                          title: Text("Nominal Donasi: "),
                          subtitle: Text(model.nominalDonasi),
                        ),
                        ListTile(
                          title: Text("Tanggal penutupan donasi: "),
                          subtitle: Text(
                            DateTimeFormat.format(
                              DateTime.parse(model.tanggalDonasi),
                              format: DateFormats.european,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text("Keterangan: "),
                          subtitle: Text(model.deskripsi),
                        ),
                        ListTile(
                          title: Text("Total Donasi Sekarang: "),
                          subtitle: StreamBuilder<QuerySnapshot>(
                            stream: DonasiDatabase.donasi
                                .doc(widget.idDonasi)
                                .collection("donatur")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("0");
                              }
                              snapshot.data.docs.forEach((element) {
                                total += element.data()['nominal_donasi'];
                                print("$total");
                              });
                              return Text("$total");
                            },
                          ),
                        ),
                        ExpansionTile(
                          title: Text("Daftar Donatur"),
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * (2 / 5),
                              width: double.infinity,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: DonasiDatabase.donasi
                                    .doc(widget.idDonasi)
                                    .collection("donatur")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot data =
                                          snapshot.data.docs[index];
                                      Map<String, dynamic> _donasi =
                                          data.data();
                                      return (widget.isAdmin)
                                          ? Card(
                                              color: (_donasi['konfirmasi'])
                                                  ? Colors.green[50]
                                                  : Colors.red[50],
                                              child: ListTile(
                                                title: Text(
                                                    _donasi['nama_donatur']),
                                                subtitle: Text(rupiah(
                                                    _donasi['nominal_donasi'])),
                                              ),
                                            )
                                          : (_donasi['konfirmasi'])
                                              ? Card(
                                                  child: ListTile(
                                                    title: Text(_donasi[
                                                        'nama_donatur']),
                                                    subtitle: Text(rupiah(
                                                        _donasi[
                                                            'nominal_donasi'])),
                                                  ),
                                                )
                                              : SizedBox.shrink();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: widget.isAdmin
                              ? RaisedButton(
                                  onPressed: () {
                                    Get.to(RiwayatDonasiAll(
                                      donasi: model,
                                      idDonasi: widget.idDonasi,
                                      isAdmin: widget.isAdmin,
                                      user: widget.user,
                                    ));
                                  },
                                  child: Text("Lihat semua donasi"),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Get.to(RiwayatDonasiAll(
                                          donasi: model,
                                          idDonasi: widget.idDonasi,
                                          isAdmin: widget.isAdmin,
                                          user: widget.user,
                                        ));
                                      },
                                      child: Text("Lihat semua donasi"),
                                    ),
                                    RaisedButton(
                                      onPressed: _donasi,
                                      child: Text("Donasi"),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
