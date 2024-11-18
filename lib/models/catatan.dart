import 'package:cloud_firestore/cloud_firestore.dart';

class Catatan {
  String? idCatatan;
  String idUser;
  String jenisCatatan;
  String tanggal;
  String isiCatatan;
  int jumlah;

  Catatan({
    this.idCatatan,
    required this.idUser,
    required this.jenisCatatan,
    required this.tanggal,
    required this.isiCatatan,
    required this.jumlah,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': idUser,
      'jenisCatatan': jenisCatatan,
      'tanggal': tanggal,
      'isiCatatan': isiCatatan,
      'jumlah': jumlah,
    };
  }

  factory Catatan.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Catatan(
      idCatatan: doc.id,
      idUser: data['idUser'],
      jenisCatatan: data['jenisCatatan'],
      tanggal: data['tanggal'],
      isiCatatan: data['isiCatatan'],
      jumlah: data['jumlah'],
    );
  }
}