import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/inventaris/tambahkanProduk.dart';
import 'package:umkmfirebase/screens/inventaris/tambahkanStock.dart';

class InventarisPage extends StatefulWidget {
  final UserModel user;
  InventarisPage({super.key, required this.user});

  @override
  State<InventarisPage> createState() => _InventarisPageState();
}

class _InventarisPageState extends State<InventarisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50,
      body: Padding(
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
                      builder: (context) => TambahkanProduk(user: widget.user)),
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
                      builder: (context) => TambahkanStock(user: widget.user)),
                );
              },
            ),
          ],
        ),
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
