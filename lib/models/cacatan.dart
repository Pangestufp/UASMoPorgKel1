import 'package:cloud_firestore/cloud_firestore.dart';

class Cacatan {
  String? idCacatan;
  String idUser;
  String jenisCacatan;
  String tanggal;
  String isiCacatan;
  int jumlah;

  Cacatan({
    this.idCacatan,
    required this.idUser,
    required this.jenisCacatan,
    required this.tanggal,
    required this.isiCacatan,
    required this.jumlah,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': idUser,
      'jenisCacatan': jenisCacatan,
      'tanggal': tanggal,
      'isiCacatan': isiCacatan,
      'jumlah': jumlah,
    };
  }

  factory Cacatan.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Cacatan(
      idCacatan: doc.id,
      idUser: data['idUser'],
      jenisCacatan: data['jenisCacatan'],
      tanggal: data['tanggal'],
      isiCacatan: data['isiCacatan'],
      jumlah: data['jumlah'],
    );
  }
}