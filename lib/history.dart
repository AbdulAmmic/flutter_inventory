import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Purchase> purchases = [];
  List<Purchase> filteredPurchases = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
      ),
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
                      onChanged: _filterPurchases,
                      decoration: InputDecoration(
                        hintText: 'Search Purchases',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Purchases Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildPurchasesTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchasesTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Amount')),
      ],
      rows: filteredPurchases.map((purchase) {
        return DataRow(cells: [
          DataCell(Text(purchase.date)),
          DataCell(Text(purchase.product)),
          DataCell(Text(purchase.amount.toString())),
        ]);
      }).toList(),
    );
  }

  void _filterPurchases(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPurchases = List.from(purchases);
      } else {
        filteredPurchases = purchases
            .where((purchase) =>
                purchase.date.contains(query) ||
                purchase.product.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}

class Purchase {
  String date;
  String product;
  double amount;

  Purchase({required this.date, required this.product, required this.amount});
}
