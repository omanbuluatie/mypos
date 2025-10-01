class Product {
  int? id;
  String name;
  String? barcode;
  double costPrice;
  int stock;
  int? categoryId;
  bool favorite;
  String? description;
  String? unit;
  bool isService;
  String? image;
  Map<int, double> prices; // Key: price_level_id, Value: price

  Product({
    this.id,
    required this.name,
    this.barcode,
    required this.costPrice,
    this.stock = 0,
    this.categoryId,
    this.favorite = false,
    this.description,
    this.unit,
    this.isService = false,
    this.image,
    this.prices = const {},
  });

  // This map is for the 'products' table only.
  // Prices are managed in a separate table.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'costPrice': costPrice,
      'stock': stock,
      'category_id': categoryId,
      'favorite': favorite ? 1 : 0,
      'description': description,
      'unit': unit,
      'isService': isService ? 1 : 0,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      costPrice: map['costPrice'],
      stock: map['stock'],
      categoryId: map['category_id'],
      favorite: map['favorite'] == 1,
      description: map['description'],
      unit: map['unit'],
      isService: map['isService'] == 1,
      image: map['image'],
      // prices are populated separately by the database helper
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? barcode,
    double? costPrice,
    int? stock,
    int? categoryId,
    bool? favorite,
    String? description,
    String? unit,
    bool? isService,
    String? image,
    Map<int, double>? prices,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      favorite: favorite ?? this.favorite,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      isService: isService ?? this.isService,
      image: image ?? this.image,
      prices: prices ?? this.prices,
    );
  }
}