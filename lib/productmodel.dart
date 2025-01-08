class Product {
  String? id; // Optional for new products
  String name;
  String description;

  Product({
    this.id,
    required this.name,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'], // Note: crudcrud uses '_id'
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };
}
