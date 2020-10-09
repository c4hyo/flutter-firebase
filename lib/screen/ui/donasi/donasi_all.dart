import 'package:charity_with_happiness_firebase/firebase/collection/donasi_db.dart';
import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/donasi/donasi_add.dart';
import 'package:charity_with_happiness_firebase/screen/widget/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonasiScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;
  final String kategori;

  DonasiScreen({this.profil, this.user, this.isAdmin, this.kategori});

  @override
  _DonasiScreenState createState() => _DonasiScreenState();
}

class _DonasiScreenState extends State<DonasiScreen> {
  String _cari;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Donasi ${widget.kategori}"),
        actions: [
          (widget.isAdmin)
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Get.to(
                      DonasiAddScreen(
                        profil: widget.profil,
                        user: widget.user,
                      ),
                      transition: Transition.cupertino,
                    );
                  },
                )
              : SizedBox.shrink()
        ],
        bottom: PreferredSize(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 5),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _cari = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari Berita",
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(60),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: (_cari != null && _cari != "")
              ? (widget.kategori == "")
                  ? DonasiDatabase.donasi
                      .where("searchKeyword", arrayContains: _cari)
                      .snapshots()
                  : DonasiDatabase.donasi
                      .where("searchKeyword", arrayContains: _cari)
                      .where("jenis", isEqualTo: widget.kategori)
                      .snapshots()
              : (widget.kategori == "")
                  ? DonasiDatabase.donasi.snapshots()
                  : DonasiDatabase.donasi
                      .where("jenis", isEqualTo: widget.kategori)
                      .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Donasi tidak ditemukan"),
              );
            }
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      DonasiModel model = DonasiModel.maps(data);
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: cardDonasi(context, model, data.id,
                            profilModel: widget.profil,
                            user: widget.user,
                            isAdmin: widget.isAdmin),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
