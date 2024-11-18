import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/cacatan.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class CacatanPage extends StatefulWidget {
  final UserModel user;
  CacatanPage({super.key, required this.user});

  @override
  State<CacatanPage> createState() => _CacatanPageState();
}

class _CacatanPageState extends State<CacatanPage> {
  List<Cacatan> _cacatanList = [];
  List<Cacatan> _filteredCacatanList = [];
  bool pengeluaran=false;
  int? keuntungan=0;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _isiCacatanController = TextEditingController();
  final TextEditingController _jumlahController =TextEditingController();


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

  Future<void> keuntunganBersih() async {
    List<Cacatan> cacatanList = await AppServices.readAllCacatan(widget.user);

    int totalPemasukan = 0;
    int totalPengeluaran = 0;

    for (var cacatan in cacatanList) {
      if (cacatan.jenisCacatan == "pemasukan") {
        totalPemasukan += cacatan.jumlah;
      } else if (cacatan.jenisCacatan == "pengeluaran") {
        totalPengeluaran += cacatan.jumlah;
      }
    }
    keuntungan = totalPemasukan - totalPengeluaran;
  }

  @override
  void initState() {
    super.initState();
    keuntunganBersih();
    _selectedDate = DateTime.now();
    _fetchCacatanList();
    _searchController.addListener(_filterCacatanList);
  }

  Future<void> _fetchCacatanList() async {
    _cacatanList = await AppServices.readAllCacatan(widget.user);
    setState(() {
      _filteredCacatanList = _cacatanList;
    });
  }

  void _filterCacatanList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCacatanList = _cacatanList.where((cacatan) {
        return cacatan.isiCacatan.toLowerCase().contains(query);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.black
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("keuntungan",style: TextStyle(color: Colors.white),),
                    Text(AppServices.formatRupiah(keuntungan??0), style: TextStyle(color: keuntungan!>0?Colors.green:Colors.red),)
                  ],
                ),
              ),
            ),
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Cari Cacatan",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCacatanList.length,
              itemBuilder: (context, index) {
                final cacatan = _filteredCacatanList[index];
                return ListTile(
                  title: Text(cacatan.jenisCacatan),
                  subtitle: Text(cacatan.isiCacatan),
                  trailing: Text(
                    '${cacatan.jumlah}',
                    style: TextStyle(
                      color:
                      cacatan.jenisCacatan == "pengeluaran" ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.d()
                            .format(DateTime.parse(cacatan.tanggal)),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.blue),
                      ),
                      Text(DateFormat.MMM()
                          .format(DateTime.parse(cacatan.tanggal))),
                    ],
                  )
                );
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
                                children: [
                                  Center(child: Text("Tambahkan cacatan",style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),)),
                                  Text("Jenis cacatan : "),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio<bool>(
                                            value: true,
                                            groupValue: pengeluaran,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Tanggal", style: TextStyle(color: Colors.black54, fontSize: 16)),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today, size: 20.0, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text(
                                              DateFormat.yMMMEd().format(_selectedDate ?? DateTime.now()),
                                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.arrow_drop_down, color: Colors.black54),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      DateTime pickerDate = await _selectDate(_selectedDate ?? DateTime.now());
                                      setModalState(() {
                                        _selectedDate = pickerDate;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                    InputDecoration(labelText: "Isi Cacatan"),
                                    controller: _isiCacatanController,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: "Jumlah"),
                                    controller: _jumlahController,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {

                                      AppServices.createCacatan(
                                        Cacatan(idUser: widget.user.uid, jenisCacatan: pengeluaran==true?"pengeluaran":"pemasukan", tanggal: _selectedDate.toString(), isiCacatan: _isiCacatanController.text, jumlah: int.parse(_jumlahController.text))
                                      );
                                      setState(() {
                                        _jumlahController.clear();
                                        _isiCacatanController.clear();
                                      });

                                      setModalState(() {
                                        _selectedDate = DateTime.now();
                                      });
                                      await _fetchCacatanList();
                                      await keuntunganBersih();
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
