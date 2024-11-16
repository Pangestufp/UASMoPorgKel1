import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umkmfirebase/models/transaksi.dart';

class Invoice {
  String? idInvoice;
  String idUser;
  String namaPelanggan;
  String alamat;
  String waktu;
  String urlInvoice;
  List<Transaksi> transaksiList;

  Invoice({
    this.idInvoice,
    required this.idUser,
    required this.namaPelanggan,
    required this.alamat,
    required this.waktu,
    required this.urlInvoice,
    required this.transaksiList,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'idUser':idUser,
      'namaPelanggan': namaPelanggan,
      'alamat': alamat,
      'waktu': waktu,
      'urlInvoice': urlInvoice,
      'transaksiList': transaksiList.map((transaksi) => transaksi.toFirestore()).toList(),
    };
  }

  factory Invoice.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Invoice(
      idInvoice: doc.id,
      idUser: data['idUser'],
      namaPelanggan: data['namaPelanggan'],
      alamat: data['alamat'],
      waktu: data['waktu'],
      urlInvoice: data['urlInvoice'],
      transaksiList: (data['transaksiList'] as List).map((item) => Transaksi.fromFirestore(item)).toList(),
    );
  }
}