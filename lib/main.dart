import 'package:charity_with_happiness_firebase/firebase/auth/auth.dart';
import 'package:charity_with_happiness_firebase/firebase/collection/user_db.dart';
import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/auth/login.dart';
import 'package:charity_with_happiness_firebase/screen/ui/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.checkUser,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primaryColor: Color(0xFFFFAB00),
          accentColor: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CheckScreen(),
      ),
    );
  }
}

class CheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return (user == null)
        ? LoginScreen()
        : FutureBuilder<DocumentSnapshot>(
            future: UserDatabase.getProfil(user),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              ProfilModel profil = ProfilModel.maps(snapshot.data);
              return MainPageScreen(
                isAdmin: profil.isAdmin,
                profil: profil,
                user: user,
              );
            },
          );
  }
}
