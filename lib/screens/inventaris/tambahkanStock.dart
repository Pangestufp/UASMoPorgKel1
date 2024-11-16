import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class TambahkanStock extends StatefulWidget {
  final UserModel user;
  TambahkanStock({super.key, required this.user});

  @override
  State<TambahkanStock> createState() => _TambahkanStockState();
}

class _TambahkanStockState extends State<TambahkanStock> {
  List<Barang> _barangList = [];
  List<Barang> _filteredBarangList = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _stockController=TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBarangList();
    _searchController.addListener(_filterBarangList);
  }

  Future<void> _fetchBarangList() async {
    _barangList = await AppServices.readAllBarang(widget.user);
    setState(() {
      _filteredBarangList = _barangList;
    });
  }

  void _filterBarangList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBarangList = _barangList.where((barang) {
        return barang.namaBarang.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambahkan Stock'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Barang',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBarangList.length,
              itemBuilder: (context, index) {
                final barang = _filteredBarangList[index];
                return ListTile(
                  onTap: () {
                    _stockController.text=barang.jumlahStock.toString();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                            bottom:
                            MediaQuery.of(context).viewInsets.bottom + 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                  autovalidateMode: AutovalidateMode.always,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "Jumlah Barang"),
                                        controller: _stockController,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          AppServices.updateBarang(Barang(
                                              idBarang: barang.idBarang,
                                              idUser: widget.user.uid,
                                              namaBarang:
                                              barang.namaBarang,
                                              deskripsiBarang:
                                              barang.deskripsiBarang,
                                              urlFotoBarang: barang.urlFotoBarang,
                                              hargaJual: barang.hargaJual,
                                              hargaBeli: barang.hargaBeli,
                                              jumlahStock: int.parse(_stockController.text)));

                                          setState(() {
                                            _stockController.clear();
                                          });
                                          await _fetchBarangList();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Edit"),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        );
                      },
                    );
                  },
                  title: Text(barang.namaBarang),
                  subtitle: Text(barang.deskripsiBarang),
                  trailing: Text(
                    '${barang.jumlahStock}',
                    style: TextStyle(
                      color: barang.jumlahStock == 0 ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: barang.urlFotoBarang.isNotEmpty
                      ? Image.file(
                    File(barang.urlFotoBarang),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.image, size: 50),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
