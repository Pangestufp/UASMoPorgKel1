import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/catatan.dart';
import 'package:umkmfirebase/models/invoice.dart';
import 'package:umkmfirebase/models/transaksi.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/pdfViewer/PdfViewerPage.dart';
import 'package:umkmfirebase/services/appServices.dart';

class PenjualanPage extends StatefulWidget {
  final UserModel user;
  PenjualanPage({super.key, required this.user});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  List<Barang> _barangList = [];
  List<Barang> _filteredBarangList = [];

  List<Transaksi> _transaksiList = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBarangList();
    _searchController.addListener(_filterBarangList);
  }

  void addTransaksi(Barang barang) {
    for (var transaksi in _transaksiList) {
      if (transaksi.barang.idBarang == barang.idBarang) {
        if(transaksi.total<barang.jumlahStock){
          transaksi.total += 1;
        }
        return;
      }
    }
    _transaksiList.add(Transaksi(barang: barang, total: 1));
  }

  Future<void> updateStock() async {
    for (var transaksi in _transaksiList) {
      transaksi.barang.jumlahStock -= transaksi.total;

      await AppServices.updateBarang(transaksi.barang);
    }
  }

  int hitungKeuntungan() {
    int totalKeuntungan = 0;

    for (var transaksi in _transaksiList) {
      int keuntunganPerTransaksi = (transaksi.barang.hargaJual - transaksi.barang.hargaBeli) * transaksi.total;
      totalKeuntungan += keuntunganPerTransaksi;
    }

    return totalKeuntungan;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Cari Produk",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _filteredBarangList.length,
                itemBuilder: (context, index) {
                  final barang = _filteredBarangList[index];
                  return GestureDetector(
                    onTap: () {
                      if(barang.jumlahStock>0) {
                        addTransaksi(barang);
                      }
                      setState(() {});
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FutureBuilder<bool>(
                              future: File(barang.urlFotoBarang).exists(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasData && snapshot.data == true) {
                                  return Image.file(
                                    File(barang.urlFotoBarang),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                } else {
                                  return Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      barang.namaBarang,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      barang.jumlahStock.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 1),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Masukan data"),
                          content: Container(
                            height: 150,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Nama Pelanggan",
                                  ),
                                  controller: _namaController,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Alamat Pelanggan",
                                  ),
                                  controller: _alamatController,
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.amber),
                                )),
                            TextButton(
                                onPressed: () async {
                                  await updateStock();

                                  AppServices.createCatatan(
                                      Catatan(idUser: widget.user.uid, jenisCatatan: "pemasukan", tanggal: DateTime.now().toString(), isiCatatan: "Penjualan Item atas nama ${_namaController.text}", jumlah: hitungKeuntungan())
                                  );
                                  
                                  String? pdf =
                                      await AppServices.createInvoicePDF(
                                          Invoice(
                                              idUser: widget.user.uid,
                                              namaPelanggan:
                                                  _namaController.text,
                                              alamat: _alamatController.text,
                                              waktu: DateTime.now().toString(),
                                              urlInvoice: "Null",
                                              transaksiList: _transaksiList), widget.user);

                                  AppServices.createInvoice(Invoice(
                                      idUser: widget.user.uid,
                                      namaPelanggan: _namaController.text,
                                      alamat: _alamatController.text,
                                      waktu: DateTime.now().toString(),
                                      urlInvoice: "${pdf}",
                                      transaksiList: _transaksiList));


                                  _transaksiList.clear();
                                  _alamatController.clear();
                                  _namaController.clear();
                                  setState(() {

                                  });
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewerPage(path: pdf!)));
                                },
                                child: Text("Oke",
                                    style: TextStyle(color: Colors.amber)))
                          ],
                        );
                      });
                },
                child: Text("Check Out"),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _transaksiList.length,
                itemBuilder: (context, index) {
                  final transaksi = _transaksiList[index];
                  return ListTile(
                    title: Text(transaksi.barang.namaBarang),
                    subtitle: Text(AppServices.formatRupiah(transaksi.barang.hargaJual)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (transaksi.total > 1) {
                                transaksi.total = transaksi.total - 1;
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.remove)),
                        Text(
                          '${transaksi.total}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if(transaksi.barang.jumlahStock>transaksi.total){
                                transaksi.total = transaksi.total + 1;
                              }
                              setState(() {});
                            },
                            icon: Icon(Icons.add)),
                      ],
                    ),
                    leading: transaksi.barang.urlFotoBarang.isNotEmpty
                        ? Image.file(
                            File(transaksi.barang.urlFotoBarang),
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
      ),
    );
  }
}
