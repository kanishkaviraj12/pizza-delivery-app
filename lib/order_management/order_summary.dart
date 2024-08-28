import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderSummaryPage extends StatelessWidget {
  final String pizzaName;
  final String description;
  final String imageUrl;
  final double price;
  final int quantity;
  final String selectedSize;
  final String userEmail; // Add this parameter

  const OrderSummaryPage({
    super.key,
    required this.pizzaName,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.selectedSize,
    required this.userEmail, // Add this parameter
  });

  Future<void> _saveOrder(BuildContext context) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final String orderId = _generateRandomOrderId();
    final double totalPrice = price * quantity;

    try {
      await _db.collection('orders').doc(orderId).set({
        'pizzaName': pizzaName,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'selectedSize': selectedSize,
        'totalPrice': totalPrice,
        'status': 'Awaiting Payment',
        'timestamp': FieldValue.serverTimestamp(),
        'userEmail': userEmail, // Save user email
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
        ),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      print('Error saving order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error placing order. Please try again.'),
        ),
      );
    }
  }

  String _generateRandomOrderId() {
    final Random random = Random();
    final int randomNumber = 10000 + random.nextInt(90000);
    return randomNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pizzaName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Size: $selectedSize',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            Text(
              'Quantity: $quantity',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveOrder(context),
                child: const Text('Confirm Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
