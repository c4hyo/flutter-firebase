import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDatabase {
  static CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  static Future<DocumentSnapshot> getProfil(User user) async {
    try {
      return await users.doc(user.uid).get();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> updateProfil(User user, {ProfilModel model}) async {
    try {
      return await users.doc(user.uid).set(
        {
          "nama": model.nama,
          "telepon": model.telepon,
          "tempat_lahir": model.tempatLahir,
          "tanggal_lahir": model.tanggalLahir,
          "pekerjaan": model.pekerjaan,
          "alamat": model.alamat,
          "foto_profil": model.fotoProfil
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
