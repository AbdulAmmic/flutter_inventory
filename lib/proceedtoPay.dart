import 'package:flutter/material.dart';

class ProceedPayScreen extends StatefulWidget {
  @override
  _ProceedPayScreenState createState() => _ProceedPayScreenState();
}

class _ProceedPayScreenState extends State<ProceedPayScreen> {
  String selectedCustomer = 'Guest';
  String guestPhoneNumber = '';
  String guestAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proceed to Pay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Include your summary here

            SizedBox(height: 20),

            Text(
              'Select Payment Method:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Guest payment
                    _showGuestDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Guest',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Customer payment
                    _showCustomerDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Customer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGuestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Guest Payment'),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number (Optional)'),
                onChanged: (value) {
                  guestPhoneNumber = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address (Optional)'),
                onChanged: (value) {
                  guestAddress = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Process guest payment
                _proceedToPrintReceipt();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Print Receipt',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Customer Payment'),
          content: Column(
            children: [
              DropdownButton<String>(
                value: selectedCustomer,
                onChanged: (String? value) {
                  setState(() {
                    selectedCustomer = value!;
                  });
                },
                items: <String>['Guest', 'Customer 1', 'Customer 2', 'Customer 3']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Process customer payment
                _proceedToPrintReceipt();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Print Receipt',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPrintReceipt() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrintReceiptScreen(
          customerName: selectedCustomer,
          phoneNumber: guestPhoneNumber,
          address: guestAddress,
        ),
      ),
    );
  }
}

class PrintReceiptScreen extends StatelessWidget {
  final String customerName;
  final String phoneNumber;
  final String address;

  PrintReceiptScreen({
    required this.customerName,
    required this.phoneNumber,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Receipt'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'MINDLAB AFRICA STORE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Katsina State, Nigeria',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Contact: 07087577535',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Customer: $customerName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              if (customerName == 'Guest')
                Column(
                  children: [
                    Text(
                      'Phone Number: $phoneNumber',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Address: $address',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Text(
                'Goods Purchased:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add a list of purchased goods with prices here
              SizedBox(height: 20),
              Text(
                'Total Price: \$XXX', // Add the actual total price here
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement the logic to print the receipt
                  // This is where you generate PDF or take any other action based on the platform
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Print',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
