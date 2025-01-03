import 'dart:io';
import 'package:bounce_tapper/bounce_tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

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
        if (transaksi.total < barang.jumlahStock) {
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
      int keuntunganPerTransaksi =
          (transaksi.barang.hargaJual - transaksi.barang.hargaBeli) *
              transaksi.total;
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  labelText: "Cari Produk",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.teal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.teal[700]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  )),
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
                      if (barang.jumlahStock > 0) {
                        addTransaksi(barang);
                      }
                      setState(() {});
                    },
                    child: BounceTapper(
                      child: Card(
                        color: Colors.teal[700],
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        barang.namaBarang,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        barang.jumlahStock.toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().scale(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
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
                            child: Form(
                              key: _globalKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Nama Pelanggan",
                                          suffixIcon: Icon(
                                            Icons.person,
                                            color: Colors.teal,
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 2.0,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 2.0,
                                            ),
                                          )),
                                      controller: _namaController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Nama tidak boleh kosong';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Alamat Pelanggan",
                                          suffixIcon: Icon(
                                            Icons.place,
                                            color: Colors.teal,
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 2.0,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                              width: 2.0,
                                            ),
                                          )),
                                      controller: _alamatController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Alamat tidak boleh kosong';
                                        }
                                        return null;
                                      })
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.teal),
                                )),
                            TextButton(
                                onPressed: () async {
                                  if (_globalKey.currentState!.validate()) {
                                    String? pdf =
                                        await AppServices.createInvoicePDF(
                                            Invoice(
                                                idUser: widget.user.uid,
                                                namaPelanggan:
                                                    _namaController.text,
                                                alamat: _alamatController.text,
                                                waktu:
                                                    DateTime.now().toString(),
                                                urlInvoice: "Null",
                                                transaksiList: _transaksiList),
                                            widget.user);

                                    AppServices.createInvoice(Invoice(
                                        idUser: widget.user.uid,
                                        namaPelanggan: _namaController.text,
                                        alamat: _alamatController.text,
                                        waktu: DateTime.now().toString(),
                                        urlInvoice: "${pdf}",
                                        transaksiList: _transaksiList));

                                    await updateStock();

                                    AppServices.createCatatan(Catatan(
                                        idUser: widget.user.uid,
                                        jenisCatatan: "pemasukan",
                                        tanggal: DateTime.now().toString(),
                                        isiCatatan:
                                            "Penjualan Item atas nama ${_namaController.text}",
                                        jumlah: hitungKeuntungan()));

                                    _transaksiList.clear();
                                    _alamatController.clear();
                                    _namaController.clear();
                                    setState(() {});
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PdfViewerPage(path: pdf!)));
                                  }
                                },
                                child: Text("Cetak",
                                    style: TextStyle(color: Colors.teal)))
                          ],
                        );
                      });
                },
                child: Text(
                  "Check Out",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 1,
              color: Colors.teal,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.teal[700],
                    height: 2,
                  );
                },
                itemCount: _transaksiList.length,
                itemBuilder: (context, index) {
                  final transaksi = _transaksiList[index];
                  return ListTile(
                    title: Text(transaksi.barang.namaBarang),
                    subtitle: Text(
                        AppServices.formatRupiah(transaksi.barang.hargaJual)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (transaksi.total > 1) {
                                  transaksi.total -= 1;
                                } else {
                                  _transaksiList.removeAt(index);
                                }
                              });
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
                              if (transaksi.barang.jumlahStock >
                                  transaksi.total) {
                                transaksi.total += 1;
                              }
                              setState(() {});
                            },
                            icon: Icon(Icons.add)),
                      ],
                    ),
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: transaksi.barang.urlFotoBarang.isNotEmpty
                          ? FutureBuilder<bool>(
                        future: File(transaksi.barang.urlFotoBarang).exists(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            return ClipRRect(
                              child: Image.file(
                                File(transaksi.barang.urlFotoBarang),
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            );
                          }
                        },
                      )
                          : Icon(Icons.image, color: Colors.grey),
                    ),
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
