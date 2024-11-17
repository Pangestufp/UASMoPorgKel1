import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/invoice.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/screens/pdfViewer/PdfViewerPage.dart';
import 'package:umkmfirebase/services/appServices.dart';

class InvoicePage extends StatefulWidget {
  final UserModel user;
  InvoicePage({super.key, required this.user});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Invoice> _invoiceList = [];
  List<Invoice> _filteredInvoiceList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInvoiceList();
    _searchController.addListener(_filterInvoiceList);
  }

  Future<void> _fetchInvoiceList() async {
    _invoiceList = await AppServices.readAllInvoice(widget.user);
    setState(() {});
  }

  void _filterInvoiceList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInvoiceList = _invoiceList.where((invoice) {
        return invoice.namaPelanggan.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Cari Pembeli",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredInvoiceList.length,
              itemBuilder: (context, index) {
                final invoice = _filteredInvoiceList[index];
                return ListTile(
                    title: Text(invoice.namaPelanggan),
                    subtitle: Text(invoice.alamat),
                    trailing: IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewerPage(path: invoice.urlInvoice)));
                    }, icon: Icon(Icons.open_in_new)),
                    leading: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.d()
                              .format(DateTime.parse(invoice.waktu)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.blue),
                        ),
                        Text(DateFormat.MMM()
                            .format(DateTime.parse(invoice.waktu))),
                      ],
                    )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
