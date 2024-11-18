import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:umkmfirebase/models/pengingat.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/invoice/invoicePage.dart';
import 'package:umkmfirebase/screens/pengaturan/pengaturan.dart';
import 'package:umkmfirebase/screens/cacatan/cacatanPage.dart';
import 'package:umkmfirebase/screens/home/homePage.dart';
import 'package:umkmfirebase/screens/inventaris/inventarisPage.dart';
import 'package:umkmfirebase/screens/laporanKeuangan/keuanganPage.dart';
import 'package:umkmfirebase/screens/pengingat/pengingatPage.dart';
import 'package:umkmfirebase/screens/penjualan/penjualanPage.dart';
import 'package:umkmfirebase/services/appServices.dart';
import 'package:umkmfirebase/services/auth.dart';

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
  int? jumlahPengingat;

  Future<void> getJumlahPengingat() async {
    List<Pengingat> pengingatList = await AppServices.readAllPengingat(user!);

    jumlahPengingat = pengingatList.length;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? uid = widget.firebaseUser.uid;
    UserModel? fetchedUser = await AppServices.getUserData(uid!);
    setState(() async {
      user = fetchedUser;

      _listPages = [
        HomePage(changePage: _changePage, user: user!),
        InventarisPage(user: user!),
        CacatanPage(user: user!),
        PenjualanPage(
          user: user!,
        ),
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
      await getJumlahPengingat();

    });
  }

  void _changePage(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[selectedIndex];
      _currentNamePage = _listNamePages[selectedIndex];
    });
  }

  final AuthService authService = new AuthService();


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
              backgroundColor: Color(0xFF00A86B),
            ),
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(0),
              child: _currentPage,
            )),
            bottomNavigationBar: CurvedNavigationBar(
              index: _currentIndex,
              height: 50,
              color: Color(0xFF00A86B),
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
            ),
            drawer: _currentIndex == 0
                ? Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        UserAccountsDrawerHeader(
                          currentAccountPicture: Icon(
                            Icons.face,
                            size: 48.0,
                            color: Colors.white,
                          ),
                          accountName: Text(
                            "${user!.namaUMKM}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          accountEmail: Text("${user!.alamatUMKM}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)),
                          otherAccountsPictures: <Widget>[
                            Icon(
                              Icons.bookmark_border,
                              color: Colors.amber,
                            )
                          ],
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/drawerGambar.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.notification_important,
                                color: Colors.amber,
                                size: 40,
                              ),
                              trailing: jumlahPengingat!=0? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${jumlahPengingat}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ):null,
                              title: Text("Pengingat"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PengingatPage(user: user!,)));
                              },
                            ),
                            Divider(color: Colors.amber,),
                            ListTile(
                              leading: Icon(
                                Icons.save_alt,
                                color: Colors.amber,
                                size: 40,
                              ),
                              title: Text("Invoice"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => InvoicePage(user: user!)));
                              },
                            ),
                            Divider(color: Colors.amber,),
                            ListTile(
                              leading: Icon(
                                Icons.settings,
                                color: Colors.amber,
                                size: 40,
                              ),
                              title: Text("Setting"),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Pengaturan(user: user!,)));
                              },
                            ),
                            Divider(color: Colors.amber,),
                            ListTile(
                              leading: Icon(
                                Icons.logout_sharp,
                                color: Colors.red,
                                size: 40,
                              ),
                              title: Text(
                                "Log Out",
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () async {
                                Navigator.pop(context);
                                await authService.signOut();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : null,
          );
  }
}
