import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:receiptocr/src/controllers/helper.dart';
import 'package:receiptocr/src/models/recin.dart';
import 'package:receiptocr/src/views/ocr_result.dart';

class DetailView extends StatefulWidget {
  const DetailView({Key? key, this.recIn}) : super(key: key);
  final RecIn? recIn;
  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  String details = '';
  @override
  void initState() {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    details = encoder.convert(widget.recIn!.toMap());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          IconButton(
            onPressed: compare,
            icon: const Icon(Icons.compare),
          ),
          IconButton(
            onPressed: viewImage,
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Text(details),
      ),
    );
  }

  compare() {
    navTo(context, const OcrResult());
  }

  viewImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PhotoView(
                imageProvider: NetworkImage(
                    'https://receipt-and-invoice-rest-api.herokuapp.com/api/v1/images/${widget.recIn!.imageid}'),
              ),
              Positioned(
                top: 25,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
