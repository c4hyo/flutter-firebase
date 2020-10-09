import 'package:cloud_firestore/cloud_firestore.dart';

class DonasiModel {
  String uid;
  String judul;
  String deskripsi;
  String jenis;
  String nominalDonasi;
  String tanggalDonasi;
  String infoDonasi;
  String waktuPosting;
  String penulis;
  String thumbnail;

  DonasiModel({
    this.uid,
    this.deskripsi,
    this.judul,
    this.jenis,
    this.penulis,
    this.thumbnail,
    this.waktuPosting,
    this.infoDonasi,
    this.nominalDonasi,
    this.tanggalDonasi,
  });

  factory DonasiModel.maps(DocumentSnapshot doc) {
    return DonasiModel(
      uid: doc.id,
      judul: doc.data()['judul'] ?? "",
      jenis: doc.data()['jenis'] ?? "",
      infoDonasi: doc.data()['info_donasi'] ?? "",
      nominalDonasi: doc.data()['nominal_donasi'] ?? "",
      tanggalDonasi: doc.data()['tanggal_donasi'] ?? "",
      deskripsi: doc.data()['deskripsi'] ?? "",
      waktuPosting: doc.data()['waktu_posting'].toString() ?? "",
      penulis: doc.data()['penulis'] ?? "",
      thumbnail: doc.data()['thumbnail'] ?? "",
    );
  }
}
