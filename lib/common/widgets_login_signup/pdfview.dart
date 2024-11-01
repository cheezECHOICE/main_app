import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PDFViewerScreen({Key? key, required this.pdfPath, required this.title}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late String localPath;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final file = await _copyAssetToLocal(widget.pdfPath);
    setState(() {
      localPath = file.path;
    });
  }

  Future<File> _copyAssetToLocal(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: localPath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath,
            ),
    );
  }
}
