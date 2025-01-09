import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/subScreen/function/downloadFunction.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final TextEditingController _pageController = TextEditingController();
  // late PdfViewerController _pdfViewerController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    // _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    DownloadPdf downloadPdf = DownloadPdf();
    return Scaffold(
      appBar: AppBar(
        title: _isSearchActive
            ? TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Page Number',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_pageController.text.isNotEmpty) {
                        int pageNumber = int.tryParse(_pageController.text) ?? 1;
                        // _navigateToPage(pageNumber);
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    int pageNumber = int.tryParse(value) ?? 1;
                    // _navigateToPage(pageNumber);
                  }
                },
              )
            : Text("PDF Viewer"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                if (!_isSearchActive) {
                  _pageController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.blue),
            onPressed: () {
              // downloadPdf.downloadPdf(
              //   context,
              //   widget.pdfPath,
              //   '${widget.pdfPath.split('/').last}.pdf',
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: widget.pdfPath.startsWith('http')
          //       ? SfPdfViewer.network(
          //           widget.pdfPath,
          //           controller: _pdfViewerController,
          //         )
          //       : SfPdfViewer.file(
          //           File(widget.pdfPath),
          //           controller: _pdfViewerController,
          //         ),
          // ),
        ],
      ),
    );
  }

  // void _navigateToPage(int pageNumber) {
  //   final totalPages = _pdfViewerController.pageCount ?? 1;
  //   if (pageNumber > 0 && pageNumber <= totalPages) {
  //     _pdfViewerController.jumpToPage(pageNumber);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid page number')));
  //   }
  // }
}
