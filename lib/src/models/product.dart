class Product {
  final String name;
  final int quantity;
  final String unitprice;
  final int ratiokdv;
  final String category;

  const Product({
    this.name = '',
    this.quantity = 0,
    this.unitprice = '',
    this.ratiokdv = 0,
    this.category = '',
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        name: map['Name'],
        quantity: map['Quantity'],
        unitprice: map['UnitPrice'],
        ratiokdv: map['RatioKdv'],
        category: map['Category'],
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'Name': name,
        'Quantity': quantity,
        'UnitPrice': unitprice,
        'RatioKdv': ratiokdv,
        'Category': category,
      };
}
