import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Widget _buildStatusRadio(
      String orderId, String currentStatus, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: currentStatus == status ? Colors.orange : Colors.grey[200],
        border: Border.all(
          color: currentStatus == status ? Colors.orange : Colors.grey[400]!,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: Text(
          status,
          style: TextStyle(
            color: currentStatus == status ? Colors.white : Colors.black87,
          ),
        ),
        leading: Radio<String>(
          value: status,
          groupValue: currentStatus,
          onChanged: null, // Disable interaction
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text("No user logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('userEmail', isEqualTo: currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text("No orders found for ${currentUser!.email}"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;
              String currentStatus = order['status'] ?? 'Awaiting Payment';

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: $orderId",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total Price: \$${order['totalPrice']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Current Status: $currentStatus",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Update Status:",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      _buildStatusRadio(
                          orderId, currentStatus, 'Awaiting Payment'),
                      _buildStatusRadio(orderId, currentStatus, 'On the Way'),
                      _buildStatusRadio(orderId, currentStatus, 'Delivered'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
