import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leveleight/productmodel.dart';

class ProductApiService {
  static const String baseUrl =
      'https://crudcrud.com/api/0d1973e9c8df4b2f8c7d3c1bee34fdef/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<void> editProduct(String id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to edit product');
      }
    } catch (e) {
      throw Exception('Error editing product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
