import 'package:bounce_tapper/bounce_tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class HomePage extends StatefulWidget {
  final Function(int) changePage;
  final UserModel user;

  HomePage({super.key, required this.changePage, required this.user});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12, // Background color yang lebih terang

      body: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: headerSection(),
              ),

              // Menu Cards
              showMenu(),

              // Informasi dan Pengingat
              infoAndReminderSection(),

            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.teal[200], // Warna latar belakang header
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, color: Colors.white, size: 40.0),
          SizedBox(width: 10),
          Text(
            widget.user.namaUMKM,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget showMenu() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          // First Row of Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuItem("Inventaris", "assets/icons/inventory.png", 1),
              menuItem("Cacatan", "assets/icons/note.png", 2),
              menuItem("Penjualan", "assets/icons/cart.png", 3),
            ],
          ),
          SizedBox(height: 20),
          // Second Row of Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuItem("Keuangan", "assets/icons/report.png", 4),
              menuItem("Download", "assets/icons/tersimpan.png", 5),
              menuItem("Pengingat", "assets/icons/pengingat.png", 6),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuItem(String title, String iconPath, int pageIndex) {
    return GestureDetector(
      onTap: () {
        widget.changePage(pageIndex);
      },
      child: BounceTapper(
        child: Card(
          color: Colors.teal[400], // Warna Card untuk menu
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              height: 80,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(iconPath, scale: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ).animate().scale(),
      ),
    );
  }

  // Section untuk menampilkan informasi bisnis
  Widget infoAndReminderSection() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informasi Bisnis",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
          SizedBox(height: 10),
          Card(
            color: Colors.deepPurple[100],
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Perbarui informasi bisnis untuk melanjutkan proses pencatatan dan keuangan secara otomatis.",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Pengingat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
          SizedBox(height: 10),
          Card(
            color: Colors.orange[100],
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Pastikan untuk memeriksa laporan keuangan dan stok barang hari ini.",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }




}
