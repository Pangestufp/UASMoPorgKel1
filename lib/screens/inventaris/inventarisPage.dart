import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/inventaris/tambahkanProduk.dart';
import 'package:umkmfirebase/screens/inventaris/tambahkanStock.dart';
import 'package:umkmfirebase/services/appServices.dart';

class InventarisPage extends StatefulWidget {
  final UserModel user;
  InventarisPage({super.key, required this.user});

  @override
  State<InventarisPage> createState() => _InventarisPageState();
}

class _InventarisPageState extends State<InventarisPage> {
  List<Barang> _barangList = [];
  int _jumlahBarang = 0;
  int _jumlahTotalStock = 0;
  int _rata=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBarangList();
  }

  Future<void> _fetchBarangList() async {
    _barangList = await AppServices.readAllBarang(widget.user);
    hitungJumlahBarangDanStock();
    setState(() {});
  }

  int hitungRataRataStock() {
    if (_jumlahBarang == 0) return 0;
    return (_jumlahTotalStock ~/ _jumlahBarang);
  }

  void hitungJumlahBarangDanStock() {
    _jumlahBarang = _barangList.length;
    _jumlahTotalStock = _barangList.fold(0, (total, barang) => total + barang.jumlahStock);
    _rata=hitungRataRataStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(
                  "Tambahkan Barang",
                  Icons.add_box,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TambahkanProduk(user: widget.user)),
                    );
                  },
                ),
                _buildCard(
                  "Tambahkan Stok",
                  Icons.inventory,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TambahkanStock(user: widget.user)),
                    );
                  },
                ),
              ],
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32), topLeft: Radius.circular(32)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(32)),
                  color: Colors.white),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Penyimpanan",
                      style: TextStyle(
                        color: Colors.teal[800],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Card untuk Jumlah Barang
                    Card(
                      color: Colors.teal[50],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.inventory, color: Colors.teal[700], size: 28),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Jumlah barang: ${_jumlahBarang}",
                                style: TextStyle(
                                  color: Colors.teal[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Card untuk Jumlah Total Stok
                    Card(
                      color: Colors.teal[50],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.storage, color: Colors.teal[700], size: 28),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Jumlah total stok: ${_jumlahTotalStock}",
                                style: TextStyle(
                                  color: Colors.teal[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Card untuk Jumlah Rata-rata Stok
                    Card(
                      color: Colors.teal[50],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.show_chart, color: Colors.teal[700], size: 28),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Jumlah rata-rata stok: ${_rata}",
                                style: TextStyle(
                                  color: Colors.teal[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.teal[400],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ).animate().scale(),
    );
  }
}
