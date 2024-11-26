import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:umkmfirebase/models/pengingat.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/invoice/invoicePage.dart';
import 'package:umkmfirebase/screens/pengaturan/pengaturan.dart';
import 'package:umkmfirebase/screens/catatan/catatanPage.dart';
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

  void showStockReminderPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 40,
                color: Colors.orange[700],
              ),
              SizedBox(height: 8),
              Text(
                "Pengingat Stock",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Divider(thickness: 2),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Anda memiliki ${jumlahPengingat} stok yang belum dilunaskan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.check_circle, color: Colors.teal[700]),
              label: Text(
                "Oke",
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Future<void> fetchUserData() async {
    String? uid = widget.firebaseUser.uid;
    UserModel? fetchedUser = await AppServices.getUserData(uid!);
    setState(() async {
      user = fetchedUser;

      _listPages = [
        HomePage(changePage: _changePage, user: user!, updateJumlahPengingat: updateJumlahPengingat,),
        InventarisPage(user: user!, updateJumlahPengingat: updateJumlahPengingat,),
        CatatanPage(user: user!),
        PenjualanPage(
          user: user!,
        ),
        KeuanganPage(user: user!),
      ];

      _listNamePages = [
        "Beranda",
        "Inventaris",
        "Catatan",
        "Penjualan",
        "Keuangan",
      ];

      _currentPage = _listPages[0];
      _currentNamePage = _listNamePages[0];
      await getJumlahPengingat();
      if(jumlahPengingat!>0){
        showStockReminderPopup(context);
      }

    });
  }

  Future<void> updateJumlahPengingat() async {
    await getJumlahPengingat();
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
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: LottieBuilder.asset("assets/images/loading.json")),
    )
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
                            Icons.store_outlined,
                            size: 70.0,
                            color: Colors.teal[700],
                          ),
                          accountName: Text(
                            "${user!.namaUMKM}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30,
                                color: Colors.black),
                          ),
                          accountEmail: Text("${user!.alamatUMKM}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15,
                                  color: Colors.black54)),
                          otherAccountsPictures: <Widget>[
                            Icon(
                              Icons.bookmark_border,
                              size: 35,
                              color: Colors.teal[700],
                            )
                          ],
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/halaman titik 3.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.notification_important,
                                color: Colors.teal[700],
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
                                    MaterialPageRoute(builder: (context) => PengingatPage(user: user!,updateJumlahPengingat: updateJumlahPengingat,)));
                              },
                            ),
                            Divider(color: Colors.teal[700],),
                            ListTile(
                              leading: Icon(
                                Icons.save_alt,
                                color: Colors.teal[700],
                                size: 40,
                              ),
                              title: Text("Invoice"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => InvoicePage(user: user!)));
                              },
                            ),
                            Divider(color: Colors.teal[700],),
                            ListTile(
                              leading: Icon(
                                Icons.settings,
                                color: Colors.teal[700],
                                size: 40,
                              ),
                              title: Text("Setting"),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Pengaturan(user: user!,)));
                              },
                            ),
                            Divider(color: Colors.teal[700],),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                                await authService.signOut();
                              },
                              icon: Icon(
                                Icons.logout_sharp,
                                color: Colors.white,
                                size: 24,
                              ),
                              label: Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
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
