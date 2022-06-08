import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:receiptocr/src/controllers/helper.dart';
import 'package:receiptocr/src/models/recin.dart';
import 'package:receiptocr/src/views/details.dart';

class OcrResult extends StatefulWidget {
  const OcrResult({Key? key, this.imageId}) : super(key: key);
  final String? imageId;
  @override
  State<OcrResult> createState() => _OcrResultState();
}

class _OcrResultState extends State<OcrResult> {
  RecIn? recIn;

  init() async {
    final url =
        'https://receipt-and-invoice-rest-api.herokuapp.com/api/v1/ocr/receipt/${widget.imageId}';

    final res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      final item = await json.decode(res.body);
      recIn = RecIn.fromMap(item);
    } else {
      recIn = const RecIn();
      log(res.reasonPhrase);
      log(res.body);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocr Result'),
      ),
      body: recIn == null
          ? const Center(child: CircularProgressIndicator())
          : Details(recIn: recIn),
    );
  }
}
