import 'package:charity_with_happiness_firebase/firebase/collection/donasi_db.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/other/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RiwayatDonasiScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;

  RiwayatDonasiScreen({this.user, this.profil, this.isAdmin});

  @override
  _RiwayatDonasiScreenState createState() => _RiwayatDonasiScreenState();
}

class _RiwayatDonasiScreenState extends State<RiwayatDonasiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.profil.nama}"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: DonasiDatabase.donasi.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot donasi = snapshot.data.docs[index];
                  String id = donasi.id;
                  return Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: DonasiDatabase.donasi
                            .doc(id)
                            .collection("donatur")
                            .doc(widget.user.uid)
                            .get(),
                        builder: (context, snaps) {
                          if (!snaps.hasData) {
                            return Center(
                              child: SizedBox.shrink(),
                            );
                          }
                          DocumentSnapshot donatur = snaps.data;
                          Map<String, dynamic> data2 = donatur.data();
                          if (data2 == null) {
                            return Text("");
                          } else {
                            return Card(
                              color: (!data2['konfirmasi'])
                                  ? Colors.red[50]
                                  : Colors.green[50],
                              child: ListTile(
                                title: Text('${donasi.data()['judul']}'),
                                subtitle: Text(rupiah(data2['nominal_donasi'])),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
