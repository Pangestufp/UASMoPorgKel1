
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umkmfirebase/models/barang.dart';

class Transaksi {
  String? idTransaksi;
  Barang barang;
  int total;

  Transaksi({
    this.idTransaksi,
    required this.barang,
    required this.total,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'barang': barang.toFirestore(),
      'total': total,
    };
  }

  factory Transaksi.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Transaksi(
      idTransaksi: doc.id,
      barang: Barang.fromFirestore(data['barang']),
      total: data['total'],
    );
  }

  factory Transaksi.fromMap(Map<String, dynamic> data) {
    return Transaksi(
      idTransaksi: data['idTransaksi'],
      barang: Barang.fromMap(data['barang'] as Map<String, dynamic>),
      total: data['total'] ?? 0,
    );
  }
}