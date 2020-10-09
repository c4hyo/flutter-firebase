import 'package:charity_with_happiness_firebase/firebase/auth/auth.dart';
import 'package:charity_with_happiness_firebase/firebase/collection/user_db.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/profil/profil_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class ProfilScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;

  ProfilScreen({this.user, this.profil, this.isAdmin});

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthServices.signOut();
            },
          ),
        ],
        title: Text(
          "Profile",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: UserDatabase.users.doc(widget.user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: (widget.profil.fotoProfil == "" ||
                                      widget.profil.fotoProfil == null)
                                  ? CircleAvatar(
                                      radius: 80,
                                      child: Icon(Icons.person_add),
                                    )
                                  : CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                          widget.profil.fotoProfil),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Edit Profil"),
                            trailing: Icon(FontAwesome.edit),
                            onTap: () {
                              Get.to(
                                ProfilEditScreen(
                                  profil: widget.profil,
                                  user: widget.user,
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text("Nama"),
                            subtitle: Text("${widget.profil.nama}"),
                          ),
                          ListTile(
                            title: Text("Email"),
                            subtitle: Text("${widget.user.email}"),
                          ),
                          ListTile(
                            title: Text("Nomor Telepon"),
                            subtitle: Text("${widget.profil.telepon}"),
                          ),
                          ListTile(
                            title: Text("Alamat"),
                            subtitle: Text("${widget.profil.alamat}"),
                          ),
                          ListTile(
                            title: Text("Pekerjaan"),
                            subtitle: Text("${widget.profil.pekerjaan}"),
                          ),
                          ListTile(
                            title: Text("Tempat, Tanggal Lahir"),
                            subtitle: Text(
                                "${widget.profil.tempatLahir}, ${widget.profil.tanggalLahir}"),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              DocumentSnapshot document = snapshot.data;
              ProfilModel p = ProfilModel.maps(document);
              return Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child:  (p.fotoProfil == "" ||
                                      p.fotoProfil == null)
                                  ? CircleAvatar(
                                      radius: 80,
                                      child: Icon(Icons.person_add),
                                    )
                                  : CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                          p.fotoProfil),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Edit Profil"),
                          trailing: Icon(FontAwesome.edit),
                          onTap: () {
                            Get.to(
                              ProfilEditScreen(
                                profil: widget.profil,
                                user: widget.user,
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Nama"),
                          subtitle: Text("${p.nama}"),
                        ),
                        ListTile(
                          title: Text("Email"),
                          subtitle: Text("${widget.user.email}"),
                        ),
                        ListTile(
                          title: Text("Nomor Telepon"),
                          subtitle: Text("${p.telepon}"),
                        ),
                        ListTile(
                          title: Text("Alamat"),
                          subtitle: Text("${p.alamat}"),
                        ),
                        ListTile(
                          title: Text("Pekerjaan"),
                          subtitle: Text("${p.pekerjaan}"),
                        ),
                        ListTile(
                          title: Text("Tempat, Tanggal Lahir"),
                          subtitle: Text("${p.tempatLahir}, ${p.tanggalLahir}"),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
