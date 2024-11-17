import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umkmfirebase/models/barang.dart';
import 'package:umkmfirebase/models/cacatan.dart';
import 'package:umkmfirebase/models/invoice.dart';
import 'package:umkmfirebase/models/pengingat.dart';
import 'package:umkmfirebase/models/transaksi.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AppServices {
  //data User
  static Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromFirestore(snapshot.data()!);
      } else {
        print("Data pengguna tidak ditemukan.");
        return null;
      }
    } catch (e) {
      print("Error mengambil data pengguna: $e");
      return null;
    }
  }

  //CRUD Barang
  static Future<void> createBarang(Barang barang) async {
    CollectionReference barangRef =
        FirebaseFirestore.instance.collection('barang');
    await barangRef.add(barang.toFirestore());
  }

  static Future<List<Barang>> readAllBarang(UserModel user) async {
    QuerySnapshot barangSnapshot = await FirebaseFirestore.instance
        .collection('barang')
        .where('idUser', isEqualTo: user.uid)
        .get();

    List<Barang> barangList = barangSnapshot.docs.map((doc) {
      return Barang.fromFirestore(doc);
    }).toList();

    return barangList;
  }

  static Future<void> updateBarang(Barang barang) async {
    await FirebaseFirestore.instance
        .collection('barang')
        .doc(barang.idBarang)
        .update({
      'idUser': barang.idUser,
      'namaBarang': barang.namaBarang,
      'deskripsiBarang': barang.deskripsiBarang,
      'urlFotoBarang': barang.urlFotoBarang,
      'hargaJual': barang.hargaJual,
      'hargaBeli': barang.hargaBeli,
      'jumlahStock': barang.jumlahStock,
    });
  }

  void deleteBarang(Barang barang) {
    FirebaseFirestore.instance
        .collection('barang')
        .doc(barang.idBarang)
        .delete();
  }

  //CRUD Invoice
  static Future<void> createInvoice(Invoice invoice) async {
    CollectionReference invoiceRef =
        FirebaseFirestore.instance.collection('invoice');
    await invoiceRef.add(invoice.toFirestore());
  }

  static Future<List<Invoice>> readAllInvoice(UserModel user) async {
    QuerySnapshot invoiceSnapshot = await FirebaseFirestore.instance
        .collection('invoice')
        .where('idUser', isEqualTo: user.uid)
        .get();

    List<Invoice> invoiceList = invoiceSnapshot.docs.map((doc) {
      return Invoice.fromFirestore(doc);
    }).toList();

    return invoiceList;
  }

  static Future<void> updateInvoice(Invoice invoice) async {
    await FirebaseFirestore.instance
        .collection('invoice')
        .doc(invoice.idInvoice)
        .update({
      'idUser': invoice.idUser,
      'namaPelanggan': invoice.namaPelanggan,
      'alamat': invoice.alamat,
      'waktu': invoice.waktu,
      'urlInvoice': invoice.urlInvoice,
      'transaksiList': invoice.transaksiList
          .map((transaksi) => transaksi.toFirestore())
          .toList(),
    });
  }

  static Future<void> deleteInvoice(Invoice invoice) async {
    await FirebaseFirestore.instance
        .collection('invoice')
        .doc(invoice.idInvoice)
        .delete();
  }

  //CRUD Cacatan
  static Future<void> createCacatan(Cacatan cacatan) async {
    CollectionReference cacatanRef =
        FirebaseFirestore.instance.collection('cacatan');
    await cacatanRef.add(cacatan.toFirestore());
  }

  static Future<List<Cacatan>> readAllCacatan(UserModel user) async {
    QuerySnapshot cacatanSnapshot = await FirebaseFirestore.instance
        .collection('cacatan')
        .where('idUser', isEqualTo: user.uid)
        .get();

    List<Cacatan> cacatanList = cacatanSnapshot.docs.map((doc) {
      return Cacatan.fromFirestore(doc);
    }).toList();

    return cacatanList;
  }

  static Future<void> updateCacatan(Cacatan cacatan) async {
    await FirebaseFirestore.instance
        .collection('cacatan')
        .doc(cacatan.idCacatan)
        .update({
      'idUser': cacatan.idUser,
      'jenisCacatan': cacatan.jenisCacatan,
      'tanggal': cacatan.tanggal,
      'isiCacatan': cacatan.isiCacatan,
      'jumlah': cacatan.jumlah,
    });
  }

  static Future<void> deleteCacatan(Cacatan cacatan) async {
    await FirebaseFirestore.instance
        .collection('cacatan')
        .doc(cacatan.idCacatan)
        .delete();
  }


  //CRUD Pengingat
  static Future<void> createPengingat(Pengingat pengingat) async {
    CollectionReference pengingatRef =
    FirebaseFirestore.instance.collection('pengingat');
    await pengingatRef.add(pengingat.toFirestore());
  }

  static Future<List<Pengingat>> readAllPengingat(UserModel user) async {
    QuerySnapshot pengingatSnapshot = await FirebaseFirestore.instance
        .collection('pengingat')
        .where('idUser', isEqualTo: user.uid)
        .get();

    List<Pengingat> pengingatList = pengingatSnapshot.docs.map((doc) {
      return Pengingat.fromFirestore(doc);
    }).toList();

    return pengingatList;
  }

  static Future<void> updatePengingat(Pengingat pengingat) async {
    await FirebaseFirestore.instance
        .collection('pengingat')
        .doc(pengingat.idPengingat)
        .update({
      'idUser': pengingat.idUser,
      'tanggal': pengingat.tanggal,
      'isi': pengingat.isi,
    });
  }

  static Future<void> deletePengingat(Pengingat pengingat) async {
    await FirebaseFirestore.instance
        .collection('pengingat')
        .doc(pengingat.idPengingat)
        .delete();
  }


  //UploadFile
  static Future<String> saveFileLocally(File file) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = path.join(appDocDir.path, path.basename(file.path));
    await file.copy(localPath);
    return localPath;
  }





  static Future<String?> createInvoicePDF(Invoice invoice, UserModel user) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          // Hitung total keseluruhan harga
          final totalKeseluruhan = invoice.transaksiList.fold<double>(
            0,
                (sum, transaksi) => sum + (transaksi.barang.hargaJual * transaksi.total),
          );

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Invoice',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Nama UMKM: ${user.namaUMKM}'),
              pw.Text('Alamat UMKM: ${user.alamatUMKM}'),
              pw.Text('Nama Pelanggan: ${invoice.namaPelanggan}'),
              pw.Text('Alamat: ${invoice.alamat}'),
              pw.Text('Tanggal: ${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.parse(invoice.waktu))}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Daftar Transaksi',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('Nama Barang', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('Deskripsi Barang', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('Jumlah', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('Harga per Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('Total Harga', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...invoice.transaksiList.map(
                        (Transaksi transaksi) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(transaksi.barang.namaBarang),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(transaksi.barang.deskripsiBarang),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(transaksi.total.toString()),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text("Rp ${transaksi.barang.hargaJual.toStringAsFixed(2)}"),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text("Rp ${(transaksi.barang.hargaJual * transaksi.total).toStringAsFixed(2)}"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total Keseluruhan:',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    "Rp ${totalKeseluruhan.toStringAsFixed(2)}",
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      final outputDir = await getTemporaryDirectory();
      final filePath = '${outputDir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      print('Invoice PDF berhasil dibuat di: $filePath');
      return filePath;
    } catch (e) {
      print('Terjadi kesalahan saat membuat PDF: $e');
      return null;
    }
  }


}
