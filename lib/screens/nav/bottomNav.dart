import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/cacatan/cacatanPage.dart';
import 'package:umkmfirebase/screens/home/homePage.dart';
import 'package:umkmfirebase/screens/inventaris/inventarisPage.dart';
import 'package:umkmfirebase/screens/laporanKeuangan/keuanganPage.dart';
import 'package:umkmfirebase/screens/penjualan/penjualanPage.dart';
import 'package:umkmfirebase/services/appServices.dart';

class BottomNav extends StatefulWidget {
  final FirebaseUser firebaseUser;
  BottomNav({super.key, required this.firebaseUser});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  UserModel? user;

  int _currentIndex = 0;
  List<Widget> _listPages = [];
  List<String> _listNamePages = [];

  Widget? _currentPage;
  String? _currentNamePage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? uid = widget.firebaseUser.uid;
    UserModel? fetchedUser = await AppServices.getUserData(uid!);
    setState(() {
      user = fetchedUser;

      _listPages = [
        HomePage(changePage: _changePage, user: user!),
        InventarisPage(user: user!),
        CacatanPage(user: user!),
        PenjualanPage(user: user!,),
        KeuanganPage(user: user!),
      ];

      _listNamePages = [
        "Beranda",
        "Inventaris",
        "Cacatan",
        "Penjualan",
        "Keuangan",
      ];

      _currentPage = _listPages[0];
      _currentNamePage = _listNamePages[0];
    });
  }


  void _changePage(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[selectedIndex];
      _currentNamePage = _listNamePages[selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Center(
                child: Text(
                  "${_currentNamePage}",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              backgroundColor: Colors.black,
            ),
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(0),
              child: _currentPage,
            )),
            bottomNavigationBar: CurvedNavigationBar(
              index: _currentIndex,
              height: 50,
              color: Colors.black,
              backgroundColor: Colors.white,
              animationDuration: Duration(milliseconds: 500),
              items: [
                Icon(
                  _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  _currentIndex == 1
                      ? Icons.inventory
                      : Icons.inventory_2_outlined,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  _currentIndex == 2 ? Icons.note_add : Icons.note_add_outlined,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  _currentIndex == 3
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  _currentIndex == 4
                      ? Icons.monetization_on
                      : Icons.monetization_on_outlined,
                  size: 25,
                  color: Colors.white,
                ),
              ],
              onTap: (selectedIndex) => _changePage(selectedIndex),
            ));
  }
}
