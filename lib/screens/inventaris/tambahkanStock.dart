import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/pengingat.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class TambahkanStock extends StatefulWidget {
  final UserModel user;
  final Future<void> Function() updateJumlahPengingat;
  TambahkanStock({super.key, required this.user,required this.updateJumlahPengingat});


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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal[700],
            hintColor: Colors.green,
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white
          ),
          child: child!,
        );
      },
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
        backgroundColor: Colors.teal[700],
        title: Text('Tambahkan Stock',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Barang',

                prefixIcon: Icon(Icons.search,color: Colors.teal,),
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
                  )

              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index){
                return Divider(
                  color: Colors.teal[700],
                  height: 2,
                );
              },
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Status Pembayaran : ",style: TextStyle(color: Colors.teal),),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Radio<bool>(
                                                  value: true,
                                                  activeColor: Colors.teal[700],
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
                                                  activeColor: Colors.teal[700],
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
                                              labelText: "Jumlah Barang",


                                              labelStyle: TextStyle(color: Colors.teal[700]),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
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
                                              focusedErrorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.teal,
                                                  width: 2.0,
                                                ),
                                              )


                                          ),
                                          controller: _stockController,
                                        ),
                                        Center(
                                          child: ElevatedButton(
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

                                                await widget.updateJumlahPengingat();
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
                                            child: Text("Tambahkan Stock",style: TextStyle(color: Colors.teal[700]),),
                                          ),
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
                                            labelText: "Jumlah Barang",
                                            labelStyle: TextStyle(color: Colors.teal[700]),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
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
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.teal,
                                                width: 2.0,
                                              ),
                                            )

                                        ),
                                        controller: _stockController,
                                        keyboardType: TextInputType.number,
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
                                        child: Text("Edit Stock",style: TextStyle(color: Colors.teal[700]),),
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
                      fontSize: 16
                    ),
                  ),
                  leading: barang.urlFotoBarang.isNotEmpty
                      ? FutureBuilder<bool>(
                    future: File(barang.urlFotoBarang).exists(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData && snapshot.data == true) {
                        return Image.file(
                          File(barang.urlFotoBarang),fit: BoxFit.cover,width: 50,
                        );
                      } else {
                        return Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        );
                      }
                    },
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
