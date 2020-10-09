import 'package:charity_with_happiness_firebase/firebase/collection/user_db.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAllScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;

  UserAllScreen({this.isAdmin, this.profil, this.user});
  @override
  _UserAllScreenState createState() => _UserAllScreenState();
}

class _UserAllScreenState extends State<UserAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Pengguna"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: UserDatabase.users
              .where("is_admin", isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return (snapshot.data.docs.length == 0)
                ? Center(
                    child: Text("Tidak ada pengguna"),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data.docs[index];
                      ProfilModel profil = ProfilModel.maps(document);
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(profil.nama),
                          leading: Container(
                            height: 80,
                            width: 80,
                            child: (profil.fotoProfil == "" ||
                                    profil.fotoProfil == null)
                                ? CircleAvatar(
                                    radius: 70,
                                    child: Icon(Icons.person),
                                  )
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundImage:
                                        NetworkImage(profil.fotoProfil),
                                  ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
