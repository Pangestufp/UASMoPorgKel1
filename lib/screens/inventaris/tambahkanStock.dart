import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/pengingat.dart';
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
  final TextEditingController _stockController = TextEditingController();

  bool? isPaid = false;
  DateTime? _selectedDate;
  Future<DateTime> _selectDate(DateTime selectedDate) async {
    DateTime _initialDate = selectedDate;
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (_pickedDate != null) {
      selectedDate = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          _initialDate.hour,
          _initialDate.minute,
          _initialDate.second,
          _initialDate.millisecond,
          _initialDate.microsecond);
    }
    return selectedDate;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
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
                    _stockController.text = "0";
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
                                  MediaQuery.of(context).viewInsets.bottom + 16,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Form(
                                    autovalidateMode: AutovalidateMode.always,
                                    child: Column(
                                      children: [
                                        Text("Status Pembayaran : "),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Radio<bool>(
                                                  value: true,
                                                  groupValue: isPaid,
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      isPaid = value;
                                                    });
                                                  },
                                                ),
                                                Text("Lunas"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio<bool>(
                                                  value: false,
                                                  groupValue: isPaid,
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      isPaid = value;
                                                    });
                                                  },
                                                ),
                                                Text("Belum Lunas"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (isPaid == false)
                                          TextButton(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Tanggal jatuh tempo pembayaran",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 16)),
                                                SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    Icon(Icons.calendar_today,
                                                        size: 20.0,
                                                        color: Colors.black54),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      DateFormat.yMMMEd()
                                                          .format(
                                                              _selectedDate ??
                                                                  DateTime
                                                                      .now()),
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(Icons.arrow_drop_down,
                                                        color: Colors.black54),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              DateTime pickerDate =
                                                  await _selectDate(
                                                      _selectedDate ??
                                                          DateTime.now());
                                              setModalState(() {
                                                _selectedDate = pickerDate;
                                              });
                                            },
                                          ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: "Jumlah Barang"),
                                          controller: _stockController,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            AppServices.updateBarang(Barang(
                                                idBarang: barang.idBarang,
                                                idUser: widget.user.uid,
                                                namaBarang: barang.namaBarang,
                                                deskripsiBarang:
                                                    barang.deskripsiBarang,
                                                urlFotoBarang:
                                                    barang.urlFotoBarang,
                                                hargaJual: barang.hargaJual,
                                                hargaBeli: barang.hargaBeli,
                                                jumlahStock: barang
                                                        .jumlahStock +
                                                    int.parse(_stockController
                                                        .text)));

                                            if (isPaid == false) {
                                              AppServices.createPengingat(Pengingat(
                                                  idUser: widget.user.uid,
                                                  tanggal:
                                                      _selectedDate.toString(),
                                                  isi:
                                                      "Item(${barang.namaBarang}) sejumlah ${int.parse(_stockController.text)} belum lunas"));
                                            }
                                            setState(() {
                                              _stockController.clear();
                                            });
                                            setModalState(() {
                                              _selectedDate = DateTime.now();
                                            });
                                            await _fetchBarangList();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Tambahkan Stock"),
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
                  onLongPress: () {
                    _stockController.text = barang.jumlahStock.toString();
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
                                              namaBarang: barang.namaBarang,
                                              deskripsiBarang:
                                                  barang.deskripsiBarang,
                                              urlFotoBarang:
                                                  barang.urlFotoBarang,
                                              hargaJual: barang.hargaJual,
                                              hargaBeli: barang.hargaBeli,
                                              jumlahStock: int.parse(
                                                  _stockController.text)));

                                          setState(() {
                                            _stockController.clear();
                                          });
                                          await _fetchBarangList();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Edit Stock"),
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
                      color:
                          barang.jumlahStock == 0 ? Colors.red : Colors.black,
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
