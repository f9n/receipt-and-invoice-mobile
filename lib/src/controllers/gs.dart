import 'dart:convert';
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import '../models/recin.dart';

final gs = _GS();

class _GS {
  final root = 'https://receipt-and-invoice-rest-api.herokuapp.com/api/v1/';
  List<String> categories = [];

  getCategories() async {
    final res = await get(Uri.parse('${root}configs'));
    if (res.statusCode == 200) {
      final data = await json.decode(res.body);
      categories = List<String>.from(data['product']['categories']);
    }
  }

  Future<List<RecIn>> fetch(String slug) async {
    final res = await _mget(slug);
    return res.map<RecIn>((e) => RecIn.fromMap(e)).toList();
  }

  Future ocr(String imagePath, String slug) async {
    var req = MultipartRequest('POST', Uri.parse('${root}ocr/$slug'));
    req.headers.addAll({'accept': 'application/json'});
    req.files.add(
      await MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType('image', 'png'),
      ),
    );
    final stream = await req.send();
    final res = await Response.fromStream(stream);
    if (res.statusCode == 200) {
      final data = await json.decode(res.body);
      return RecIn.fromMap(data);
    }
    return null;
  }

  add(Map payload, String slug) {
    return _mpost('${slug}s', payload);
  }

  remove(String id, String slug) async {
    await delete(
      Uri.parse('$root${slug}s/$id'),
      headers: {'accept': 'application/json'},
    );
  }

  Future _mget(String uri) async {
    final res = await get(
      Uri.parse(root + uri),
      headers: {'accept': 'application/json'},
    );
    if (res.statusCode == 200) {
      return await json.decode(utf8.decode(res.bodyBytes));
    }
  }

  Future _mpost(String uri, Map payload) async {
    final res = await post(
      Uri.parse('$root$uri/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );
    if (res.statusCode == 200) {
      return await json.decode(utf8.decode(res.bodyBytes));
    }
  }
}
