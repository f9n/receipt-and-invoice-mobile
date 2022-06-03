import 'metadata.dart';
import 'product.dart';

class RecIn {
  final String firm;
  final String no;
  final String date;
  final String totalamount;
  final String totalkdv;
  final List<Product> products;
  final String imageid;
  final String id;
  final MetaData metadata;

  const RecIn({
    this.firm = '',
    this.no = '',
    this.date = '',
    this.totalamount = '',
    this.totalkdv = '',
    this.products = const [],
    this.imageid = '',
    this.id = '',
    this.metadata = const MetaData(),
  });

  factory RecIn.fromMap(Map<String, dynamic> map) => RecIn(
        firm: map['Firm'],
        no: map['No'],
        date: map['Date'],
        totalamount: map['TotalAmount'],
        totalkdv: map['TotalKdv'],
        products:
            (map['Products'].map<Product>((e) => Product.fromMap(e)).toList()),
        imageid: map['ImageId'],
        id: map['_id'],
        metadata: MetaData.fromMap(map['Metadata']),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'Firm': firm,
        'No': no,
        'Date': date,
        'TotalAmount': totalamount,
        'TotalKdv': totalkdv,
        'Products': products.map((e) => e.toMap()).toList(),
        'ImageId': imageid,
        '_id': id,
        'Metadata': metadata.toMap(),
      };
}
