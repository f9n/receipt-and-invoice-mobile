import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class OcrResult extends StatefulWidget {
  const OcrResult({Key? key, this.id}) : super(key: key);
  final String? id;
  @override
  State<OcrResult> createState() => _OcrResultState();
}

class _OcrResultState extends State<OcrResult> {
  String? details;

  init() async {
    final url =
        'https://receipt-and-invoice-rest-api.herokuapp.com/api/v1/ocr/receipt';
    final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
      final items = await json.decode(res.body);
    final item = items.firstWhere((e)=>e['_id']=='6266f75df5bafb7f7b24c182', orElse: () => null);
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      if(item != null){
        details = encoder.convert(item);

      }else{
        details = 'Not found!';
      }
    }
    details = res.reasonPhrase;
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: details == null
            ? const Center(child: CircularProgressIndicator())
            : Text(details!),
      ),
    );
  }
}
