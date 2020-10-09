import 'package:charity_with_happiness_firebase/firebase/collection/berita_db.dart';
import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/berita/berita_add.dart';
import 'package:charity_with_happiness_firebase/screen/widget/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeritaAllScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;
  BeritaAllScreen({this.profil, this.user, this.isAdmin});
  @override
  _BeritaAllScreenState createState() => _BeritaAllScreenState();
}

class _BeritaAllScreenState extends State<BeritaAllScreen> {
  String _cari;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Berita"),
        actions: [
          widget.isAdmin
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Get.to(
                      BeritaAddScreen(
                        profil: widget.profil,
                        user: widget.user,
                      ),
                      transition: Transition.cupertino,
                    );
                  },
                )
              : SizedBox.shrink(),
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
              ? BeritaDatabase.berita
                  .where("searchKeyword", arrayContains: _cari)
                  .orderBy("waktu_posting", descending: true)
                  .snapshots()
              : BeritaDatabase.berita
                  .orderBy("waktu_posting", descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Beirta tidak ditemukan"),
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
                      BeritaModel model = BeritaModel.maps(data);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: cardBerita(context, model, data.id,
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
