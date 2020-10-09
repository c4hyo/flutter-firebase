import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/berita/berita_detail.dart';
import 'package:charity_with_happiness_firebase/screen/ui/donasi/donasi_detail.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget cardBerita(
    BuildContext context, BeritaModel beritaModel, String idBerita,
    {User user, ProfilModel profilModel, bool isAdmin}) {
  return GestureDetector(
    onTap: () {
      Get.to(BeritaDetailScreen(
        berita: beritaModel,
        idBerita: idBerita,
        user: user,
        isAdmin: isAdmin,
      ));
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * (1 / 3),
          color: Theme.of(context).accentColor,
          child: (beritaModel.thumbnail == "")
              ? Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 80,
                  ),
                )
              : Image(
                  image: NetworkImage(beritaModel.thumbnail),
                ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * (1 / 8),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text(beritaModel.judul),
              subtitle: Text(
                DateTimeFormat.format(DateTime.parse(beritaModel.waktuPosting),
                    format: DateTimeFormats.european),
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget cardDonasi(
    BuildContext context, DonasiModel donasiModel, String idDonasi,
    {User user, ProfilModel profilModel, bool isAdmin}) {
  return GestureDetector(
    onTap: () {
      Get.to(
        DonasiDetailScreen(
          donasi: donasiModel,
          idDonasi: idDonasi,
          profil: profilModel,
          user: user,
          isAdmin: isAdmin,
        ),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * (1 / 3),
          color: Theme.of(context).accentColor,
          child: (donasiModel.thumbnail == "")
              ? Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 80,
                  ),
                )
              : Image(
                  image: NetworkImage(donasiModel.thumbnail),
                ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * (1 / 8),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text(donasiModel.judul),
              subtitle: Text(
                DateTimeFormat.format(DateTime.parse(donasiModel.waktuPosting),
                    format: DateTimeFormats.european),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
