// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ValueNotifier<List<Map<String, String>>> productsNotifier =
      ValueNotifier([]);

  void addProduct(String name, String description) {
    productsNotifier.value = [
      ...productsNotifier.value,
      {'name': name, 'description': description}
    ];
  }

  void editProduct(int index, String name, String description) {
    final updatedProducts =
        List<Map<String, String>>.from(productsNotifier.value);
    updatedProducts[index] = {'name': name, 'description': description};
    productsNotifier.value = updatedProducts;
  }

  void deleteProduct(int index) {
    final updatedProducts =
        List<Map<String, String>>.from(productsNotifier.value)..removeAt(index);
    productsNotifier.value = updatedProducts;
  }

  void showProductDialog(BuildContext context, {int? index}) {
    final nameController = TextEditingController(
      text: index != null ? productsNotifier.value[index]['name'] : '',
    );
    final descriptionController = TextEditingController(
      text: index != null ? productsNotifier.value[index]['description'] : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Add Product' : 'Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Product Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();

                if (index == null) {
                  addProduct(name, description);
                } else {
                  editProduct(index, name, description);
                }
                Navigator.pop(context);
              },
              child: Text(index == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: const Text('Manage Products'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => showProductDialog(context),
            child: const Text('Add Product'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: productsNotifier,
              builder: (context, products, child) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(product['name']!),
                        subtitle: Text(product['description']!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  showProductDialog(context, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteProduct(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product['name']} deleted successfully'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
