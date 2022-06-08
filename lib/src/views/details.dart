import 'package:flutter/material.dart';

import '../models/recin.dart';

class Details extends StatefulWidget {
  const Details({Key? key, this.recIn}) : super(key: key);
  final RecIn? recIn;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<String> mainFields = []; // 4
  List<Map<String, dynamic>> productFields = []; // ?:5

  @override
  void initState() {
    final r = widget.recIn!;
    mainFields = [r.firm, r.no, r.date, r.totalamount, r.totalkdv];
    productFields = r.products.map((e) => e.toMap()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const SizedBox(height: 10),
        title('Main Fields'),
        const SizedBox(height: 8),
        divider,
        row('Firm', 0, true),
        divider,
        row('No', 1, true),
        divider,
        row('Date', 2, true),
        divider,
        row('Total Amount', 3, true),
        divider,
        row('TotalKdv', 4, true),
        divider,
        const SizedBox(height: 20),
        title('Products'),
        ...products(),
      ],
    );
  }

  List<Widget> products() {
    List<Widget> children = [];
    for (int i = 0; i < productFields.length; i++) {
      children.add(block(productFields[i], i));
    }
    return children;
  }

  Widget block(Map map, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlueAccent.withAlpha(55),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: title('Product ${index + 1}', isMedium: true),
          ),
          const SizedBox(height: 5),
          for (MapEntry x in map.entries) ...[
            divider,
            row(x.key, index, false),
          ],
        ],
      ),
    );
  }

  Widget divider = Container(height: 0.5, color: Colors.black12);

  Widget title(str, {bool isMedium = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        str,
        style: TextStyle(
          fontWeight: isMedium ? FontWeight.w500 : FontWeight.bold,
        ),
      ),
    );
  }

  Widget row(String title, int index, bool isMain) {
    final str = title == 'Category'
        ? productFields[index][title]
        : isMain
            ? mainFields[index]
            : '${productFields[index][title]}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: SizedBox(
        height: 23,
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(title),
            ),
            const VerticalDivider(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(str),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
