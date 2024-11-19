import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/services/appServices.dart';

class Detailbarang extends StatefulWidget {
  final Barang benda;
  Detailbarang({super.key, required this.benda});

  @override
  State<Detailbarang> createState() => _DetailbarangState();
}

class _DetailbarangState extends State<Detailbarang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50,
      appBar: AppBar(
        title: Text(
          widget.benda.namaBarang,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade100,
                            Colors.green.shade300,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    widget.benda.urlFotoBarang.isNotEmpty
                        ? FutureBuilder<bool>(
                            future: File(widget.benda.urlFotoBarang).exists(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (snapshot.hasData && snapshot.data == true) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    File(widget.benda.urlFotoBarang),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                );
                              }
                            },
                          )
                        : Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.benda.namaBarang,
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Deskripsi: ${widget.benda.deskripsiBarang}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Harga Beli : ' +
                              AppServices.formatRupiah(widget.benda.hargaBeli),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Harga Jual : ' +
                              AppServices.formatRupiah(widget.benda.hargaJual),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50), // Tambahkan jarak di atas tombol
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Text(
                                  "Konfirmasi Hapus",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                content: Container(
                                  width: double.maxFinite,
                                  height: 50,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Apakah anda ingin menghapus ${widget.benda.namaBarang} ?",
                                        style: TextStyle(
                                            color: Colors.teal[700],
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.check_circle,
                                        color: Colors.teal[700]),
                                    label: Text(
                                      "Kembali",
                                      style: TextStyle(
                                        color: Colors.teal[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      AppServices.deleteBarang(widget.benda);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.check_circle,
                                        color: Colors.red),
                                    label: Text(
                                      "Oke",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.red),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Kembali",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
