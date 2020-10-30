import 'package:charity_with_happiness_firebase/firebase/collection/user_db.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User> signUp({
    String email,
    String password,
    String nama,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await UserDatabase.users.doc(userCredential.user.uid).set({
        "nama": nama,
        "telepon": null,
        "tempat_lahir": null,
        "tanggal_lahir": null,
        "pekerjaan": null,
        "alamat": null,
        "is_admin": false,
        "foto_profil": null,
      });
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<User> signIn({
    String email,
    String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return e;
    }
  }

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Stream<User> get checkUser => _auth.authStateChanges();
}
