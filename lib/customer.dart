import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

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
                      onChanged: _filterCustomers,
                      decoration: InputDecoration(
                        hintText: 'Search Customers',
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
                          title: 'Add Customer',
                          icon: Icons.add,
                          onPressed: () {
                            _showAddCustomerDialog(context);
                          },
                        ),
                        _buildInnerCard(
                          icon: Icons.people,
                          title: '${filteredCustomers.length} Customers',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Customers Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildCustomersTable(),
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

  Widget _buildCustomersTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Address')),
        DataColumn(label: Text('Balance')),
        DataColumn(label: Text('Phone Number')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Delete')),
      ],
      rows: filteredCustomers.map((customer) {
        return DataRow(cells: [
          DataCell(Text(customer.name)),
          DataCell(Text(customer.address)),
          DataCell(Text(customer.balance.toString())),
          DataCell(Text(customer.phoneNumber)),
          DataCell(
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditCustomerDialog(context, customer);
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, customer);
              },
            ),
          ),
        ]);
      }).toList(),
    );
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCustomers = List.from(customers);
      } else {
        filteredCustomers = customers
            .where((customer) =>
                customer.name.toLowerCase().contains(query.toLowerCase()) ||
                customer.address.toLowerCase().contains(query.toLowerCase()) ||
                customer.phoneNumber.contains(query))
            .toList();
      }
    });
  }

  void _showAddCustomerDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController balanceController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: balanceController,
                decoration: InputDecoration(labelText: 'Wallet Balance'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addCustomer(
                  name: nameController.text,
                  address: addressController.text,
                  balance: double.tryParse(balanceController.text) ?? 0.0,
                  phoneNumber: phoneNumberController.text,
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

  void _addCustomer({required String name, required String address, required double balance, required String phoneNumber}) {
    setState(() {
      customers.add(Customer(name: name, address: address, balance: balance, phoneNumber: phoneNumber));
      _filterCustomers('');
    });
  }

  void _showEditCustomerDialog(BuildContext context, Customer customer) {
    TextEditingController nameController = TextEditingController(text: customer.name);
    TextEditingController addressController = TextEditingController(text: customer.address);
    TextEditingController balanceController = TextEditingController(text: customer.balance.toString());
    TextEditingController phoneNumberController = TextEditingController(text: customer.phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Customer'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: balanceController,
                decoration: InputDecoration(labelText: 'Wallet Balance'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateCustomer(
                  customer,
                  name: nameController.text,
                  address: addressController.text,
                  balance: double.tryParse(balanceController.text) ?? 0.0,
                  phoneNumber: phoneNumberController.text,
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

  void _updateCustomer(Customer customer, {required String name, required String address, required double balance, required String phoneNumber}) {
    setState(() {
      customer.name = name;
      customer.address = address;
      customer.balance = balance;
      customer.phoneNumber = phoneNumber;
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Customer'),
          content: Text('Are you sure you want to delete ${customer.name}?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _deleteCustomer(customer);
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

  void _deleteCustomer(Customer customer) {
    setState(() {
      customers.remove(customer);
      _filterCustomers('');
    });
  }
}

class Customer {
  String name;
  String address;
  double balance;
  String phoneNumber;

  Customer({required this.name, required this.address, required this.balance, required this.phoneNumber});
}
