//// filepath: /C:/Users/lisan/Desktop/Workspaces/app_planes/lib/widgets/perfil/viewPdf.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerPage extends StatefulWidget {
  final File file;

  const PdfViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.file.path),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizar Reporte')),
      body: PdfView(
        controller: _pdfController,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
