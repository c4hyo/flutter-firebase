import 'package:charity_with_happiness_firebase/model/profil_model.dart';
import 'package:charity_with_happiness_firebase/screen/ui/donasi/riwayat_donasi.dart';
import 'package:charity_with_happiness_firebase/screen/ui/home.dart';
import 'package:charity_with_happiness_firebase/screen/ui/profil/profil_screen.dart';
import 'package:charity_with_happiness_firebase/screen/ui/user/user_all.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MainPageScreen extends StatefulWidget {
  final User user;
  final ProfilModel profil;
  final bool isAdmin;
  MainPageScreen({this.user, this.profil, this.isAdmin});
  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  int _selectTab = 0;
  ProfilModel profil;
  List<Widget> _tabs() => [
        HomeScreen(
          user: widget.user,
          profil: widget.profil,
          isAdmin: widget.isAdmin,
        ),
        (widget.isAdmin)
            ? UserAllScreen(
                isAdmin: widget.isAdmin,
                profil: widget.profil,
                user: widget.user,
              )
            : RiwayatDonasiScreen(
                user: widget.user,
                profil: widget.profil,
                isAdmin: widget.isAdmin,
              ),
        ProfilScreen(
          user: widget.user,
          profil: widget.profil,
          isAdmin: widget.isAdmin,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tab = _tabs();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Beranda"),
          ),
          (widget.isAdmin)
              ? BottomNavigationBarItem(
                  icon: Icon(FontAwesome.users), title: Text("Useer"))
              : BottomNavigationBarItem(
                  icon: Icon(FontAwesome.history),
                  title: Text("Riwayat"),
                ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesome.user_circle),
            title: Text("Profil"),
          ),
        ],
        currentIndex: _selectTab,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        iconSize: 40,
        onTap: (v) {
          setState(() {
            _selectTab = v;
          });
        },
      ),
      body: SafeArea(
        child: _tab[_selectTab],
      ),
    );
  }
}
