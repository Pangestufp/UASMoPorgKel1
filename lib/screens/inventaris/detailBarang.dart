import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/barang.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.benda.namaBarang,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.benda.urlFotoBarang.isNotEmpty
                  ? Image.file(
                File(widget.benda.urlFotoBarang),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 200,
                height: 200,
                color: Colors.grey,
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.benda.namaBarang,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            Text(
              widget.benda.deskripsiBarang,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Harga Beli: Rp${widget.benda.hargaBeli}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Harga Jual: Rp${widget.benda.hargaJual}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
