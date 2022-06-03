import 'package:flutter/material.dart';
import 'package:receiptocr/src/controllers/gs.dart';
import 'package:receiptocr/src/models/recin.dart';

class EditView extends StatefulWidget {
  const EditView({Key? key, this.recIn}) : super(key: key);
  final RecIn? recIn;
  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: sanitize
              Map data = widget.recIn!.toMap();
              data['Firm'] = mainFields[0];
              data['No'] = mainFields[1];
              data['Date'] = mainFields[2];
              data['TotalAmount'] = mainFields[3];
              data['TotalKdv'] = mainFields[4];

              for (int i = 0; i < productFields.length; i++) {
                final q = productFields[i]['Quantity'];
                if (q is! int) {
                  productFields[i]['Quantity'] = int.parse(q);
                }

                final rkdv = productFields[i]['RatioKdv'];
                if (rkdv is! int) {
                  productFields[i]['RatioKdv'] = int.parse(rkdv);
                }
              }

              data['Products'] = productFields;
              Navigator.of(context).pop(data);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          title('Main Fields'),
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
          title('Products'),
          ...products(),
        ],
      ),
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
        color: Colors.lightBlue.shade100,
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: title('Product ${index + 1}'),
          ),
          for (MapEntry x in map.entries) row(x.key, index, false),
        ],
      ),
    );
  }

  Widget divider = const Divider(height: 5);

  Widget title(str) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        str,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget row(String title, int index, bool isMain) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: SizedBox(
        height: 35,
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(title),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: title == 'Category'
                    ? dropdownButton(title, index)
                    : textField(title, index, isMain)),
          ],
        ),
      ),
    );
  }

  Widget textField(title, index, isMain) {
    return TextFormField(
      keyboardType: ['Quantity', 'RatioKdv'].contains(title)
          ? TextInputType.number
          : TextInputType.text,
      initialValue:
          isMain ? mainFields[index] : '${productFields[index][title]}',
      onChanged: (newVal) {
        if (isMain) {
          mainFields[index] = newVal;
        } else {
          productFields[index][title] = newVal;
        }
      },
      decoration: decor,
    );
  }

  Widget dropdownButton(title, index) {
    return DropdownButton<String>(
      value: productFields[index][title],
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() {
          productFields[index][title] = newValue!;
        });
      },
      items: gs.categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  final decor = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.only(left: 5),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
    ),
  );
}
