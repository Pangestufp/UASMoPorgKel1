import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/inventaris/detailBarang.dart';
import 'package:umkmfirebase/services/appServices.dart';

class TambahkanProduk extends StatefulWidget {
  final UserModel user;
  TambahkanProduk({super.key, required this.user});

  @override
  State<TambahkanProduk> createState() => _TambahkanProdukState();
}

class _TambahkanProdukState extends State<TambahkanProduk> {
  List<Barang> _barangList = [];
  List<Barang> _filteredBarangList = [];
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _deskripsiBarangController =
      TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();

  File? _image = null;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
        title: Text("Daftar Barang"),
      ),
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
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
                children: _filteredBarangList.map((barang) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detailbarang(benda: barang),
                        ),
                      );
                    },
                    onLongPress: () {
                      _namaBarangController.text = barang.namaBarang;
                      _deskripsiBarangController.text = barang.deskripsiBarang;
                      _hargaJualController.text = barang.hargaJual.toString();
                      _hargaBeliController.text = barang.hargaBeli.toString();
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                              builder: (context, StateSetter setModalState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        16,
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
                                                labelText: "Nama Barang"),
                                            controller: _namaBarangController,
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                labelText: "Deskripsi Barang"),
                                            controller:
                                                _deskripsiBarangController,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await _pickImage();

                                              setModalState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue,
                                                      width: 2)),
                                              child: _image == null
                                                  ? FutureBuilder<bool>(
                                                      future: File(barang
                                                              .urlFotoBarang)
                                                          .exists(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return CircularProgressIndicator();
                                                        }

                                                        if (snapshot.hasData &&
                                                            snapshot.data ==
                                                                true) {
                                                          return Image.file(
                                                            File(barang
                                                                .urlFotoBarang),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                          );
                                                        } else {
                                                          return Center(
                                                            child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              size: 50,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    )
                                                  : Image.file(
                                                      _image!,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Harga Beli Barang"),
                                            controller: _hargaBeliController,
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Harga Jual Barang"),
                                            controller: _hargaJualController,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String imageUrl;
                                              if (_image != null) {
                                                imageUrl = await AppServices
                                                    .saveFileLocally(_image!);
                                              } else {
                                                imageUrl = barang.urlFotoBarang;
                                              }

                                              AppServices.updateBarang(Barang(
                                                  idBarang: barang.idBarang,
                                                  idUser: widget.user.uid,
                                                  namaBarang:
                                                      _namaBarangController
                                                          .text,
                                                  deskripsiBarang:
                                                      _deskripsiBarangController
                                                          .text,
                                                  urlFotoBarang: imageUrl,
                                                  hargaJual: int.parse(
                                                      _hargaJualController
                                                          .text),
                                                  hargaBeli: int.parse(
                                                      _hargaBeliController
                                                          .text),
                                                  jumlahStock: barang.jumlahStock));

                                              setState(() {
                                                _image = null;
                                                _namaBarangController.clear();
                                                _deskripsiBarangController
                                                    .clear();
                                                _hargaBeliController.clear();
                                                _hargaJualController.clear();
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
                          });
                        },
                      );
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
                                  return CircularProgressIndicator();
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
                                Text(
                                  barang.namaBarang,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Harga jual Rp ${barang.hargaJual}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  "Harga beli Rp ${barang.hargaBeli}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (context, StateSetter setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Nama Barang"),
                                controller: _namaBarangController,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Deskripsi Barang"),
                                controller: _deskripsiBarangController,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _pickImage();

                                  setModalState(() {});
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue, width: 2)),
                                  child: _image == null
                                      ? Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.image_not_supported),
                                              Text("Tidak ada gambar dipilih")
                                            ],
                                          ),
                                        )
                                      : Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "Harga Beli Barang"),
                                controller: _hargaBeliController,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "Harga Jual Barang"),
                                controller: _hargaJualController,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  String imageUrl =
                                      await AppServices.saveFileLocally(
                                          _image!);

                                  AppServices.createBarang(Barang(
                                      idUser: widget.user.uid,
                                      namaBarang: _namaBarangController.text,
                                      deskripsiBarang:
                                          _deskripsiBarangController.text,
                                      urlFotoBarang: imageUrl,
                                      hargaJual:
                                          int.parse(_hargaJualController.text),
                                      hargaBeli:
                                          int.parse(_hargaBeliController.text),
                                      jumlahStock: 0));
                                  setState(() {
                                    _image = null;
                                    _namaBarangController.clear();
                                    _deskripsiBarangController.clear();
                                    _hargaBeliController.clear();
                                    _hargaJualController.clear();
                                  });
                                  await _fetchBarangList();
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text("Tambahkan"),
                              ),
                            ],
                          ))
                    ],
                  ),
                );
              });
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
