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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchInvoiceList();
    _searchController.addListener(_filterInvoiceList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInvoiceList() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      _invoiceList = await AppServices.readAllInvoice(widget.user);
      _filteredInvoiceList = _invoiceList;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Terjadi kesalahan saat mengambil data: $e';
      });
    }
  }

  void _filterInvoiceList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInvoiceList = _invoiceList.where((invoice) {
        return invoice.namaPelanggan.toLowerCase().contains(query);
      }).toList();
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data invoice...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(_error ?? 'Terjadi kesalahan'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchInvoiceList,
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('Belum ada invoice'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_filteredInvoiceList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: _filteredInvoiceList.length,
      itemBuilder: (context, index) {
        final invoice = _filteredInvoiceList[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              invoice.namaPelanggan,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(invoice.alamat),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerPage(path: invoice.urlInvoice),
                  ),
                );
              },
              icon: Icon(Icons.open_in_new, color: Colors.blue),
            ),
            leading: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.d().format(DateTime.parse(invoice.waktu)),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    DateFormat.MMM().format(DateTime.parse(invoice.waktu)),
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
        actions: [
          if (_isLoading)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 16),
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchInvoiceList,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Cari Pembeli",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

}