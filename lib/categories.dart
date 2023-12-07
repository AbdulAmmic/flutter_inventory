import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];

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
                      onChanged: _filterCategories,
                      decoration: InputDecoration(
                        hintText: 'Search Categories',
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
                          title: 'Add Category',
                          icon: Icons.add,
                          onPressed: () {
                            _showAddCategoryDialog(context);
                          },
                        ),
                        _buildInnerCard(
                          icon: Icons.category,
                          title: '${filteredCategories.length} Categories',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Categories Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildCategoriesTable(),
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

  Widget _buildCategoriesTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Delete')),
      ],
      rows: filteredCategories.map((category) {
        return DataRow(cells: [
          DataCell(Text(category.name)),
          DataCell(Text(category.description)),
          DataCell(
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditCategoryDialog(context, category);
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, category);
              },
            ),
          ),
        ]);
      }).toList(),
    );
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = List.from(categories);
      } else {
        filteredCategories = categories
            .where((category) =>
                category.name.toLowerCase().contains(query.toLowerCase()) ||
                category.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAddCategoryDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addCategory(
                  name: nameController.text,
                  description: descriptionController.text,
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

  void _addCategory({required String name, required String description}) {
    setState(() {
      categories.add(Category(name: name, description: description));
      _filterCategories('');
    });
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    TextEditingController nameController = TextEditingController(text: category.name);
    TextEditingController descriptionController = TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateCategory(
                  category,
                  name: nameController.text,
                  description: descriptionController.text,
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

  void _updateCategory(Category category, {required String name, required String description}) {
    setState(() {
      category.name = name;
      category.description = description;
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete ${category.name}?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _deleteCategory(category);
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

  void _deleteCategory(Category category) {
    setState(() {
      categories.remove(category);
      _filterCategories('');
    });
  }
}

class Category {
  String name;
  String description;

  Category({required this.name, required this.description});
}
