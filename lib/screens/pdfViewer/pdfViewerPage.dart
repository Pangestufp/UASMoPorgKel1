import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatefulWidget {
  final String path;

  PdfViewerPage({super.key, required this.path});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 0;
  int totalPages = 0;
  PDFViewController? pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadPdfFromPath();
  }

  void _loadPdfFromPath() {
    try {
      setState(() {
        localPath = widget.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Stack(
        children: [
          PDFView(
            filePath: localPath!,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageSnap: true,
            onRender: (pages) {
              setState(() {
                totalPages = pages!;
              });
            },
            onViewCreated: (PDFViewController controller) {
              pdfViewController = controller;
            },
            onPageChanged: (page, _) {
              setState(() {
                currentPage = page!;
              });
            },
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Text(
                "Page ${currentPage + 1} of $totalPages",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () async {
                    if (currentPage > 0) {
                      await pdfViewController!.setPage(currentPage - 1);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () async {
                    if (currentPage < totalPages - 1) {
                      await pdfViewController!.setPage(currentPage + 1);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
