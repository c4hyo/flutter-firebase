import 'package:cloud_firestore/cloud_firestore.dart';

class BeritaModel {
  String uid;
  String judul;
  String deskripsi;
  String waktuPosting;
  String penulis;
  String thumbnail;

  BeritaModel({
    this.uid,
    this.deskripsi,
    this.judul,
    this.penulis,
    this.thumbnail,
    this.waktuPosting,
  });

  factory BeritaModel.maps(DocumentSnapshot doc) {
    return BeritaModel(
      uid: doc.id,
      judul: doc.data()['judul'] ?? "",
      deskripsi: doc.data()['deskripsi'] ?? "",
      waktuPosting: doc.data()['waktu_posting'].toString() ?? "",
      penulis: doc.data()['penulis'] ?? "",
      thumbnail: doc.data()['thumbnail'] ?? "",
    );
  }
}
