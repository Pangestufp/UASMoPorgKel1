import 'package:cloud_firestore/cloud_firestore.dart';

class Pengingat {
  String? idPengingat;
  String idUser;
  String tanggal;
  String isi;


  Pengingat({this.idPengingat,required this.idUser,required this.tanggal,required this.isi});

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': idUser,
      'tanggal': tanggal,
      'isi': isi,
    };
  }

  factory Pengingat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Pengingat(
      idPengingat: doc.id,
      idUser: data['idUser'],
      tanggal: data['tanggal'],
      isi: data['isi'],
    );
  }
}