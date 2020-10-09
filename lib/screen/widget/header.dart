import 'package:charity_with_happiness_firebase/firebase/collection/berita_db.dart';
import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:charity_with_happiness_firebase/model/home_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/berita/berita_all.dart';
import 'package:charity_with_happiness_firebase/screen/ui/donasi/donasi_all.dart';
import 'package:charity_with_happiness_firebase/screen/widget/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width * (9 / 10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Swiper(
                      autoplay: true,
                      autoplayDelay: 2000,
                      itemCount: dataHeaderModel.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  "${dataHeaderModel[index].judul}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                child:
                                    Text("${dataHeaderModel[index].deskripsi}"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            left: 20,
            top: 20,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Charity With Happiness",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Positioned.fill(
            left: 20,
            top: 50,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "A route social movement",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Kategori extends StatelessWidget {
  final ProfilModel profil;
  final User user;
  final bool isAdmin;
  Kategori({this.isAdmin, this.profil, this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Aksi Donasi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        DonasiScreen(
                          isAdmin: isAdmin,
                          profil: profil,
                          user: user,
                          kategori: "",
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[100]),
                      child: Center(
                        child: Icon(
                          MaterialIcons.attach_money,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Text("Donasi")
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        DonasiScreen(
                          isAdmin: isAdmin,
                          profil: profil,
                          user: user,
                          kategori: "Bencana",
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[100]),
                      child: Center(
                        child: Icon(
                          MaterialIcons.home,
                          size: 40,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  Text("Bencana")
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        DonasiScreen(
                          isAdmin: isAdmin,
                          profil: profil,
                          user: user,
                          kategori: "Pendidikan",
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red[100]),
                      child: Center(
                        child: Icon(
                          MaterialIcons.people_outline,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Text("Pendidikan")
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Berita",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      BeritaAllScreen(
                        isAdmin: isAdmin,
                        profil: profil,
                        user: user,
                      ),
                    );
                  },
                  child: Text(
                    "Lihat Semua",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BeritaHome extends StatelessWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;
  BeritaHome({this.isAdmin, this.profil, this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
      height: 370,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder<QuerySnapshot>(
                stream: BeritaDatabase.berita.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      height: 350,
                      child: (snapshot.data.docs.length == 0)
                          ? Center(
                              child: Text("Tidak ada berita"),
                            )
                          : Swiper(
                              itemCount: (snapshot.data.docs.length < 3)
                                  ? snapshot.data.docs.length
                                  : 3,
                              itemBuilder: (context, index) {
                                DocumentSnapshot dat =
                                    snapshot.data.docs[index];
                                BeritaModel model = BeritaModel.maps(dat);
                                return cardBerita(
                                  context,
                                  model,
                                  dat.id,
                                  isAdmin: isAdmin,
                                  profilModel: profil,
                                  user: user,
                                );
                              },
                            ),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
