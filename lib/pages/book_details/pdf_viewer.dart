// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfViewPage extends StatefulWidget {
  final String url;
  final String name;
  PdfViewPage({
    Key? key,
    required this.url,
    required this.name,
  }) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
//    loadPdf();
    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
      ),
      body: SfPdfViewer.network(
        widget.url,
      ),
    );
  }
}

class PdfViewPageFile extends StatefulWidget {
  String url;
  final String name;
  PdfViewPageFile({
    Key? key,
    required this.url,
    required this.name,
  }) : super(key: key);
  @override
  _PdfViewPageFileState createState() => _PdfViewPageFileState();
}

class _PdfViewPageFileState extends State<PdfViewPageFile> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
//    loadPdf();
    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: SfPdfViewer.file(
        File(widget.url),
      ),
    );
  }
}
