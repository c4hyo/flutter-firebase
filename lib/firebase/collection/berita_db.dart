import 'package:charity_with_happiness_firebase/model/berita_model.dart';
import 'package:charity_with_happiness_firebase/other/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BeritaDatabase {
  static CollectionReference berita =
      FirebaseFirestore.instance.collection("berita");
  static Future<void> addBerita({BeritaModel beritaModel, User user}) async {
    try {
      return await berita.add({
        "judul": beritaModel.judul,
        "deskripsi": beritaModel.deskripsi,
        "waktu_posting": beritaModel.waktuPosting,
        "thumbnail": beritaModel.thumbnail,
        "penulis": user.uid,
        "searchKeyword": caseSearch(beritaModel.judul),
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> deleteBerita({String id}) async {
    return await berita.doc(id).delete();
  }

  static Future<void> updateBerita({String id, BeritaModel beritaModel}) async {
    return await berita.doc(id).set(
      {
        "judul": beritaModel.judul,
        "deskripsi": beritaModel.deskripsi,
        "waktu_posting": beritaModel.waktuPosting,
        "thumbnail": beritaModel.thumbnail,
        "searchKeyword": caseSearch(beritaModel.judul),
      },
      SetOptions(merge: true),
    );
  }
}
