import 'dart:js';

import 'package:flutter/material.dart';

void _proceedToPrintReceipt() {
  Navigator.push(
    context as BuildContext,
    MaterialPageRoute(
      builder: (context) => PrintReceiptScreen(
        customerName: selectedCustomer,
        phoneNumber: guestPhoneNumber,
        address: guestAddress,
      ),
    ),
  );
}

mixin guestAddress {
}

mixin guestPhoneNumber {
}

mixin selectedCustomer {
}

PrintReceiptScreen({required customerName, required phoneNumber, required address}) {
}
