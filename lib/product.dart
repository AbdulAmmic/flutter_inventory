import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // The Search bar should be somewhere around here
            Container(
              margin: EdgeInsets.only(top: 10),
              color: const Color.fromARGB(113, 255, 255, 255),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        hintText: 'Search Products',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Upper Boxes
            Container(
              margin: EdgeInsets.all(10.0),
              color: Color.fromARGB(7, 11, 11, 11),
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildInnerCard(
                          title: 'Add Product',
                          icon: Icons.add,
                          onPressed: () {
                            _showAddProductDialog(context);
                          },
                        ),
                        _buildInnerCard(
                          icon: Icons.shopping_cart,
                          title: '${filteredProducts.length} Products',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildProductsTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerCard({
    required String title,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                IconButton(
                  icon: Icon(icon),
                  onPressed: onPressed,
                ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Image')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Delete')),
      ],
      rows: filteredProducts.map((product) {
        return DataRow(cells: [
          DataCell(Text(product.name)),
          DataCell(Text(product.description)),
          DataCell(Text(product.price.toString())),
          DataCell(Text(product.stock.toString())),
          DataCell(
            Image.network(product.imageUrl),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditProductDialog(context, product);
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, product);
              },
            ),
          ),
        ]);
      }).toList(),
    );
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAddProductDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addProduct(
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  stock: int.tryParse(stockController.text) ?? 0,
                  imageUrl: imageUrlController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addProduct({required String name, required String description, required double price, required int stock, required String imageUrl}) {
    setState(() {
      products.add(Product(name: name, description: description, price: price, stock: stock, imageUrl: imageUrl));
      _filterProducts('');
    });
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    TextEditingController nameController = TextEditingController(text: product.name);
    TextEditingController descriptionController = TextEditingController(text: product.description);
    TextEditingController priceController = TextEditingController(text: product.price.toString());
    TextEditingController stockController = TextEditingController(text: product.stock.toString());
    TextEditingController imageUrlController = TextEditingController(text: product.imageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateProduct(
                  product,
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  stock: int.tryParse(stockController.text) ?? 0,
                  imageUrl: imageUrlController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateProduct(Product product, {required String name, required String description, required double price, required int stock, required String imageUrl}) {
    setState(() {
      product.name = name;
      product.description = description;
      product.price = price;
      product.stock = stock;
      product.imageUrl = imageUrl;
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _deleteProduct(product);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    setState(() {
      products.remove(product);
      _filterProducts('');
    });
  }
}

class Product {
  String name;
  String description;
  double price;
  int stock;
  String imageUrl;

  Product({required this.name, required this.description, required this.price, required this.stock, required this.imageUrl});
}
