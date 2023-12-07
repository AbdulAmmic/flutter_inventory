import 'package:appl/proceedtoPay.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardItem> cardItems = [
    CardItem('T-Shirt Xll', 'N 3788.00', 'lib/images/shirt.png'),
    CardItem('Hoodie ABC', 'N 5500.00', 'lib/images/shirt.png'),
    CardItem('Jeans XYZ', 'N 4200.00', 'lib/images/shirt.png'),
    CardItem('Sneakers', 'N 2800.00', 'lib/images/shirt.png'),
    CardItem('Backpack', 'N 3200.00', 'lib/images/shirt.png'),
    CardItem('Watch', 'N 1800.00', 'lib/images/shirt.png'),
    CardItem('Hat', 'N 1200.00', 'lib/images/shirt.png'),
    CardItem('Glasses', 'N 1000.00', 'lib/images/shirt.png'),
    CardItem('Wallet', 'N 800.00', 'lib/images/shirt.png'),
    CardItem('Belt', 'N 600.00', 'lib/images/shirt.png'),
    // Add more cards as needed
  ];

  List<SummaryItem> summaryItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
         
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search by Title',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (CardItem cardItem in cardItems)
                    if (cardItem.title.toLowerCase().contains(searchController.text.toLowerCase()))
                      _buildCard(cardItem),
                ],
              ),
            ),
          ),
          if (summaryItems.isNotEmpty)
            SizedBox(height: 20),
          if (summaryItems.isNotEmpty) _buildSummaryCard(),
          if (summaryItems.isNotEmpty)
            SizedBox(height: 20),
          if (summaryItems.isNotEmpty) _buildProceedToPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildCard(CardItem cardItem) {
    return GestureDetector(
      onTap: () {
        // Decrease quantity on tap and hide if it reaches 0
        setState(() {
          cardItem.quantity = (cardItem.quantity > 0) ? cardItem.quantity - 1 : 0;
          cardItem.isQuantityVisible = (cardItem.quantity > 0);
          if (cardItem.quantity == 0) {
            _removeFromSummary(cardItem);
          }
        });
      },
      onDoubleTap: () {
        // Increment quantity on double-tap and add to summary
        setState(() {
          cardItem.quantity++;
          cardItem.isQuantityVisible = true;
          _addToSummary(cardItem);
        });
      },
      onHorizontalDragEnd: (details) {
        // Reduce quantity on swipe
        if (details.primaryVelocity! > 0) {
          setState(() {
            cardItem.quantity = (cardItem.quantity > 0) ? cardItem.quantity - 1 : 0;
            cardItem.isQuantityVisible = (cardItem.quantity > 0);
            if (cardItem.quantity == 0) {
              _removeFromSummary(cardItem);
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 207, 203, 203).withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        width: 120,
        height: 150,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image(
              image: AssetImage(cardItem.imagePath),
              fit: BoxFit.cover,
              height: 80,
            ),
            SizedBox(height: 5),
            Text(
              cardItem.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cardItem.price,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (cardItem.isQuantityVisible)
              Text(
                'QNTY: ${cardItem.quantity}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addToSummary(CardItem cardItem) {
    int index = summaryItems.indexWhere((item) => item.title == cardItem.title);
    if (index != -1) {
      // Update existing summary item
      setState(() {
        summaryItems[index].quantity++;
        summaryItems[index].totalPrice += cardItem.priceValue;
      });
    } else {
      // Add new summary item
      setState(() {
        summaryItems.add(SummaryItem(cardItem.title, 1, cardItem.priceValue));
      });
    }
  }

  void _removeFromSummary(CardItem cardItem) {
    int index = summaryItems.indexWhere((item) => item.title == cardItem.title);
    if (index != -1) {
      setState(() {
        summaryItems.removeAt(index);
      });
    }
  }

  Widget _buildSummaryCard() {
    double totalAmount = 0;
    for (SummaryItem summaryItem in summaryItems) {
      totalAmount += summaryItem.totalPrice;
    }

    return Container(
      height: 150, // Set a fixed height for the summary card
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(0), // No curves
            // boxShadow: [Commented out to remove shadows]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              if (summaryItems.isNotEmpty)
                for (int i = 0; i < summaryItems.length; i++)
                  _buildSummaryItemRow(i + 1, summaryItems[i]),
              if (summaryItems.isEmpty && searchController.text.isNotEmpty)
                Text(
                  'No products available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: 10),
              if (summaryItems.isNotEmpty)
                Text(
                  'Total Amount: N ${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProceedToPaymentButton() {
    return ElevatedButton(
      onPressed: () {
        // Show payment confirmation modal
        _showPaymentConfirmationModal(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Text(
        'Proceed to Payment',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSummaryItemRow(int sn, SummaryItem summaryItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('S/N: $sn'),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Product: ${summaryItem.title}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10),
          Text('QNTY: ${summaryItem.quantity}'),
        ],
      ),
    );
  }

  void _showPaymentConfirmationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Payment'),
          content: Text('Do you really want to proceed with the payment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle payment confirmation
                _proceedToPaymentScreen(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPaymentScreen(BuildContext context) {
    // Navigator.pushNamed(context, '/proceedPay'); // Uncomment this line if you have a named route
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProceedPayScreen()),
    );
  }
}

class CardItem {
  final String title;
  final String price;
  final String imagePath;
  int quantity = 0;
  bool isQuantityVisible = false;

  CardItem(this.title, this.price, this.imagePath);

  double get priceValue => double.parse(price.split(' ')[1]);
}

class SummaryItem {
  final String title;
  int quantity;
  double totalPrice;

  SummaryItem(this.title, this.quantity, this.totalPrice);
}

