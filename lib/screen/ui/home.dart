import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/widget/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;
  HomeScreen({this.user, this.profil, this.isAdmin});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BerandaScreen(
      isAdmin: widget.isAdmin,
      profil: widget.profil,
      user: widget.user,
    );
  }
}

class BerandaScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;
  BerandaScreen({this.isAdmin, this.profil, this.user});
  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(),
              Kategori(
                isAdmin: widget.isAdmin,
                profil: widget.profil,
                user: widget.user,
              ),
              BeritaHome(
                isAdmin: widget.isAdmin,
                profil: widget.profil,
                user: widget.user,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
