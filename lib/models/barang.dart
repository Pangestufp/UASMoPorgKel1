import 'package:cloud_firestore/cloud_firestore.dart';

class Barang {
  String? idBarang;
  String idUser;
  String namaBarang;
  String deskripsiBarang;
  String urlFotoBarang;
  int hargaJual;
  int hargaBeli;
  int jumlahStock;

  Barang({
    this.idBarang,
    required this.idUser,
    required this.namaBarang,
    required this.deskripsiBarang,
    required this.urlFotoBarang,
    required this.hargaJual,
    required this.hargaBeli,
    required this.jumlahStock,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': idUser,
      'namaBarang': namaBarang,
      'deskripsiBarang': deskripsiBarang,
      'urlFotoBarang': urlFotoBarang,
      'hargaJual': hargaJual,
      'hargaBeli': hargaBeli,
      'jumlahStock': jumlahStock,
    };
  }

  factory Barang.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Barang(
      idBarang: doc.id,
      idUser: data['idUser'],
      namaBarang: data['namaBarang'],
      deskripsiBarang: data['deskripsiBarang'],
      urlFotoBarang: data['urlFotoBarang'],
      hargaJual: data['hargaJual'],
      hargaBeli: data['hargaBeli'],
      jumlahStock: data['jumlahStock'],
    );
  }

  factory Barang.fromMap(Map<String, dynamic> data) {
    return Barang(
      idBarang: data['idBarang'],
      idUser: data['idUser'],
      namaBarang: data['namaBarang'],
      deskripsiBarang: data['deskripsiBarang'],
      urlFotoBarang: data['urlFotoBarang'],
      hargaJual: data['hargaJual'],
      hargaBeli: data['hargaBeli'],
      jumlahStock: data['jumlahStock'],
    );
  }


}