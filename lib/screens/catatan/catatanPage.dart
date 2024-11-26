import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/catatan.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class CatatanPage extends StatefulWidget {
  final UserModel user;
  CatatanPage({super.key, required this.user});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  List<Catatan> _catatanList = [];
  List<Catatan> _filteredCatatanList = [];
  bool pengeluaran = false;
  int? keuntungan = 0;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _isiCatatanController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

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
              dialogBackgroundColor: Colors.white),
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

  Future<void> keuntunganBersih() async {
    List<Catatan> catatanList = await AppServices.readAllCatatan(widget.user);

    int totalPemasukan = 0;
    int totalPengeluaran = 0;

    for (var catatan in catatanList) {
      if (catatan.jenisCatatan == "pemasukan") {
        totalPemasukan += catatan.jumlah;
      } else if (catatan.jenisCatatan == "pengeluaran") {
        totalPengeluaran += catatan.jumlah;
      }
    }
    keuntungan = totalPemasukan - totalPengeluaran;
  }

  @override
  void initState() {
    super.initState();
    keuntunganBersih();
    _selectedDate = DateTime.now();
    _fetchCatatanList();
    _searchController.addListener(_filterCatatanList);
  }

  Future<void> _fetchCatatanList() async {
    _catatanList = await AppServices.readAllCatatan(widget.user);
    setState(() {
      _filteredCatatanList = _catatanList;
    });
  }

  void _filterCatatanList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCatatanList = _catatanList.where((catatan) {
        return catatan.isiCatatan.toLowerCase().contains(query);
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
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.teal[700],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Profit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 80,
                      width: 2,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          AppServices.formatRupiah(keuntungan ?? 0),
                          style: TextStyle(
                              color: keuntungan! > 0
                                  ? Colors.limeAccent
                                  : Colors.red,
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          keuntungan! > 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color:
                              keuntungan! > 0 ? Colors.limeAccent : Colors.red,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ).animate().scale(),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 35.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Cari Catatan",
                prefixIcon: Icon(Icons.search),
                hintStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              style: TextStyle(
                  color:
                      Colors.black),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
            color: Colors.teal[700],
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  color: Color(0xFF00A86B),
                );
              },
              itemCount: _filteredCatatanList.length,
              itemBuilder: (context, index) {
                final catatan = _filteredCatatanList[index];
                return ListTile(
                    onLongPress: () async {
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
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      "Apakah anda ingin menghapus dengan isi \"${catatan.isiCatatan}\" ?",
                                      style: TextStyle(
                                          color: Colors.teal[700]),
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
                                    AppServices.deleteCatatan(catatan);
                                    Navigator.pop(context);
                                    await _fetchCatatanList();
                                    await keuntunganBersih();
                                    setState(() {});
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
                    title: Text(
                        catatan.jenisCatatan == "pengeluaran"
                            ? "Pengeluaran"
                            : "Pemasukan",
                        style: TextStyle(
                          color: catatan.jenisCatatan == "pengeluaran"
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text(catatan.isiCatatan),
                    trailing: Text(
                      AppServices.formatRupiah(catatan.jumlah),
                      style: TextStyle(
                        color: catatan.jenisCatatan == "pengeluaran"
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.d()
                              .format(DateTime.parse(catatan.tanggal)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.teal[700]),
                        ),
                        Text(DateFormat.MMM()
                            .format(DateTime.parse(catatan.tanggal))),
                      ],
                    )).animate().fade();
              },
            ),
          )
        ],
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                  "Tambahkan catatan",
                                  style: TextStyle(
                                      color: Colors.teal[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Text("Jenis catatan : "),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio<bool>(
                                          value: true,
                                          groupValue: pengeluaran,
                                          activeColor: Colors.teal[700],
                                          onChanged: (value) {
                                            setModalState(() {
                                              pengeluaran = value!;
                                            });
                                          },
                                        ),
                                        Text("Pengeluaran"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio<bool>(
                                          value: false,
                                          groupValue: pengeluaran,
                                          activeColor: Colors.teal[700],
                                          onChanged: (value) {
                                            setModalState(() {
                                              pengeluaran = value!;
                                            });
                                          },
                                        ),
                                        Text("Pemasukan"),
                                      ],
                                    ),
                                  ],
                                ),
                                TextButton(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Tanggal",
                                          style: TextStyle(
                                              color: Colors.teal[700],
                                              fontSize: 16)),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 20.0,
                                              color: Colors.black54),
                                          SizedBox(width: 5),
                                          Text(
                                            DateFormat.yMMMEd().format(
                                                _selectedDate ??
                                                    DateTime.now()),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
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
                                    DateTime pickerDate = await _selectDate(
                                        _selectedDate ?? DateTime.now());
                                    setModalState(() {
                                      _selectedDate = pickerDate;
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Isi Catatan",
                                      labelStyle:
                                          TextStyle(color: Colors.teal[700]),
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
                                      )),
                                  controller: _isiCatatanController,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: "Jumlah",
                                      labelStyle:
                                          TextStyle(color: Colors.teal[700]),
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
                                      )),
                                  controller: _jumlahController,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      AppServices.createCatatan(Catatan(
                                          idUser: widget.user.uid,
                                          jenisCatatan: pengeluaran == true
                                              ? "pengeluaran"
                                              : "pemasukan",
                                          tanggal: _selectedDate.toString(),
                                          isiCatatan:
                                              _isiCatatanController.text,
                                          jumlah: int.parse(
                                              _jumlahController.text)));
                                      setState(() {
                                        _jumlahController.clear();
                                        _isiCatatanController.clear();
                                      });

                                      setModalState(() {
                                        _selectedDate = DateTime.now();
                                      });
                                      await _fetchCatatanList();
                                      await keuntunganBersih();
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Tambahkan",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.teal),
                                    ),
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
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF00A86B)),
    );
  }
}
