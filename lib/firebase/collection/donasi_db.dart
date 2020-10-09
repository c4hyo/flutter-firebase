import 'package:charity_with_happiness_firebase/model/donasi_model.dart';
import 'package:charity_with_happiness_firebase/other/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonasiDatabase {
  static CollectionReference donasi =
      FirebaseFirestore.instance.collection("donasi");
  static CollectionReference donatur =
      FirebaseFirestore.instance.collection("donatur");
  static Future<void> addDonasi({DonasiModel d, User user}) async {
    try {
      return await donasi.add({
        "judul": d.judul,
        "deskripsi": d.deskripsi,
        "jenis": d.jenis,
        "nominal_donasi": d.nominalDonasi,
        "tanggal_donasi": d.tanggalDonasi,
        "info_donasi": d.infoDonasi,
        "waktu_posting": d.waktuPosting,
        "penulis": user.uid,
        "thumbnail": d.thumbnail,
        "searchKeyword": caseSearch(d.judul),
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> deleteDonasi({String id}) async {
    await donasi.doc(id).collection("donatur").get().then((value) {
      value.docs.forEach((element) {
        donasi.doc(id).collection("donatur").doc(element.id).delete();
      });
    });
    return await donasi.doc(id).delete();
  }

  static Future<void> updateDonasi({String id, DonasiModel d}) async {
    try {
      return await donasi.doc(id).set(
        {
          "judul": d.judul,
          "deskripsi": d.deskripsi,
          "jenis": d.jenis,
          "nominal_donasi": d.nominalDonasi,
          "tanggal_donasi": d.tanggalDonasi,
          "info_donasi": d.infoDonasi,
          "thumbnail": d.thumbnail,
          "searchKeyword": caseSearch(d.judul),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> aksiDonasi({
    String idDonasi,
    String idUser,
    String nama,
    int nominal,
    String buktiDonasi,
  }) async {
    try {
      return await donasi.doc(idDonasi).collection("donatur").doc(idUser).set(
        {
          "nama_donatur": nama,
          "nominal_donasi": nominal,
          "bukti_donasi": buktiDonasi,
          "waktu_donasi": DateTime.now().toString(),
          "konfirmasi": false,
        },
      );
    } catch (e) {
      return print(e.toString());
    }
  }

  static Future<void> konfirmasiDonasi({String idDonasi, String idUser}) async {
    try {
      return await donasi.doc(idDonasi).collection('donatur').doc(idUser).set(
        {
          "konfirmasi": true,
        },
        SetOptions(
          merge: true,
        ),
      );
    } catch (e) {
      return e;
    }
  }
}
