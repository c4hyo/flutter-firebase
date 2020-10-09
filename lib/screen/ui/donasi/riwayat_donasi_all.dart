import 'package:charity_with_happiness_firebase/firebase/collection/donasi_db.dart';
import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:charity_with_happiness_firebase/other/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class RiwayatDonasiAll extends StatefulWidget {
  final String idDonasi;
  final DonasiModel donasi;
  final bool isAdmin;
  final User user;

  RiwayatDonasiAll({this.donasi, this.idDonasi, this.isAdmin, this.user});
  @override
  _RiwayatDonasiAllState createState() => _RiwayatDonasiAllState();
}

class _RiwayatDonasiAllState extends State<RiwayatDonasiAll> {
  _dialogKonfirmasi(String idUser, String buktiDonasi) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Konfirmasi Donasi"),
          children: [
            SimpleDialogOption(
              child: Container(
                color: Colors.grey[50],
                height: 200,
                width: 400,
                child: (buktiDonasi == "" || buktiDonasi == null)
                    ? Icon(Icons.broken_image)
                    : PhotoView(
                        imageProvider: NetworkImage(buktiDonasi),
                      ),
              ),
            ),
            SimpleDialogOption(
              child: Container(
                width: 400,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      child: Text("Konfirmasi"),
                      onPressed: () async {
                        await DonasiDatabase.konfirmasiDonasi(
                            idDonasi: widget.idDonasi, idUser: idUser);
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      child: Text("Batal"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donasi.judul),
      ),
      body: SafeArea(
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
                DocumentSnapshot document = snapshot.data.docs[index];
                Map<String, dynamic> _donasi = document.data();
                return (widget.isAdmin)
                    ? Card(
                        color: (_donasi['konfirmasi'])
                            ? Colors.green[50]
                            : Colors.red[50],
                        child: ListTile(
                          onTap: () {
                            (_donasi['konfirmasi'])
                                ? Get.snackbar(
                                    "Notifikasi", "Sudah dikonfirmasi")
                                : _dialogKonfirmasi(
                                    document.id, _donasi['bukti_donasi']);
                          },
                          title: Text(_donasi['nama_donatur']),
                          trailing: Text(
                            rupiah(_donasi['nominal_donasi']),
                          ),
                          subtitle: Text(
                            DateTimeFormat.format(
                              DateTime.parse(_donasi['waktu_donasi']),
                              format: DateFormats.european,
                            ),
                          ),
                        ),
                      )
                    : (_donasi['konfirmasi'])
                        ? Card(
                            child: ListTile(
                              title: Text(_donasi['nama_donatur']),
                              trailing: Text(
                                rupiah(_donasi['nominal_donasi']),
                              ),
                              subtitle: Text(
                                DateTimeFormat.format(
                                  DateTime.parse(_donasi['waktu_donasi']),
                                  format: DateFormats.european,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
