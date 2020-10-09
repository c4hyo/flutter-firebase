import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilModel {
  String nama;
  String telepon;
  String tempatLahir;
  String tanggalLahir;
  String pekerjaan;
  String alamat;
  String uid;
  bool isAdmin;
  String fotoProfil;

  ProfilModel({
    this.nama,
    this.alamat,
    this.pekerjaan,
    this.tanggalLahir,
    this.telepon,
    this.tempatLahir,
    this.uid,
    this.isAdmin,
    this.fotoProfil,
  });

  factory ProfilModel.maps(DocumentSnapshot doc) {
    return ProfilModel(
      uid: doc.id,
      nama: doc.data()['nama'] ?? "",
      tanggalLahir: doc.data()['tanggal_lahir'] ?? "",
      tempatLahir: doc.data()['tempat_lahir'] ?? "",
      alamat: doc.data()['alamat'] ?? "",
      pekerjaan: doc.data()['pekerjaan'] ?? "",
      isAdmin: doc.data()['is_admin'] ?? "",
      telepon: doc.data()['telepon'] ?? "",
      fotoProfil: doc.data()['foto_profil'] ?? "",
    );
  }
}
