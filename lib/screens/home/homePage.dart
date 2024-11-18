import 'package:bounce_tapper/bounce_tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:umkmfirebase/models/cacatan.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/invoice/invoicePage.dart';
import 'package:umkmfirebase/screens/pengingat/pengingatPage.dart';
import 'package:umkmfirebase/services/appServices.dart';

class HomePage extends StatefulWidget {
  final Function(int) changePage;
  final UserModel user;

  HomePage({super.key, required this.changePage, required this.user});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? keuntungan=0;

  Future<void> keuntunganBersih() async {
    List<Cacatan> cacatanList = await AppServices.readAllCacatan(widget.user);

    int totalPemasukan = 0;
    int totalPengeluaran = 0;

    for (var cacatan in cacatanList) {
      if (cacatan.jenisCacatan == "pemasukan") {
        totalPemasukan += cacatan.jumlah;
      } else if (cacatan.jenisCacatan == "pengeluaran") {
        totalPengeluaran += cacatan.jumlah;
      }
    }
    keuntungan = totalPemasukan - totalPengeluaran;
    setState(() {

    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keuntunganBersih();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50, // Background color yang lebih terang

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
      padding: EdgeInsets.only(left: 2, right: 40,top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.teal[700], // Warna latar belakang header
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.business, color: Colors.white, size: 40.0),
          Container(height: 90, width: 2, color: Colors.white,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.namaUMKM,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    AppServices.formatRupiah(keuntungan!),
                    style: TextStyle(
                      color: keuntungan!>0?Colors.limeAccent:Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(keuntungan!>0?Icons.keyboard_double_arrow_up:Icons.keyboard_double_arrow_down, color: keuntungan!>0?Colors.limeAccent:Colors.red,size: 20,)
                ],
              )


            ],
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
          SizedBox(height: 5),
          // Second Row of Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuItem("Keuangan", "assets/icons/report.png", 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoicePage(user: widget.user)));
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.teal[400],
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/tersimpan.png", scale: 10),
                            Text(
                              "Invoice",
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PengingatPage(user: widget.user)));
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.teal[400],
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/pengingat.png", scale: 10),
                            Text(
                              "Pengingat",
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
              )
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
            padding: EdgeInsets.all(8.0),
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
      margin: EdgeInsets.only(top: 10.0),
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
            "Pengingat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
          SizedBox(height: 10),
          Card(
            color: Colors.lightGreen[100],
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
          SizedBox(height: 10),
          Card(
            color: Colors.lightGreen[100],
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Selalu melihat grafik keuangan setiap bulan.",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }




}
