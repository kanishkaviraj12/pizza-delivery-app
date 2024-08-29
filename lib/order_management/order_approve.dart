import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderApprovePage extends StatefulWidget {
  @override
  _OrderApprovePageState createState() => _OrderApprovePageState();
}

class _OrderApprovePageState extends State<OrderApprovePage> {
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
      print('Attempting to update order status for $orderId to $status');
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
      print('Order status updated successfully');
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<Map<String, dynamic>> _getUserDetails(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        print('User document exists');
        print('User data: ${userDoc.data()}');
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('User document does not exist');
        return {};
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }

  Widget _buildStatusRadio(
      String orderId, String currentStatus, String status) {
    // Determine the background color based on the status
    Color getStatusColor(String status) {
      switch (status) {
        case 'Awaiting Payment':
          return const Color.fromARGB(255, 28, 164, 233);
        case 'On The Way':
          return Colors.orange;
        case 'Delivered':
          return Colors.green;
        default:
          return Colors.grey[200]!;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color:
            currentStatus == status ? getStatusColor(status) : Colors.grey[200],
        border: Border.all(
          color: currentStatus == status
              ? getStatusColor(status)
              : Colors.grey[400]!,
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
          onChanged: (value) {
            if (value != null) {
              _updateOrderStatus(orderId, value);
              setState(() {
                // This will update the UI and reflect the color change
                currentStatus = value;
              });
            }
          },
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

    bool isAdmin = currentUser!.email ==
        'admin@gmail.com'; // Replace with your admin check logic

    if (!isAdmin) {
      return Scaffold(
        body: Center(
          child: Text("Access denied. Admins only."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;
              String currentStatus = order['status'] ?? 'Awaiting Payment';
              String userEmail = order['userEmail'] ?? 'Unknown';
              String pizzaName = order['pizzaName'] ?? 'Unknown';
              String selectedSize = order['selectedSize'] ?? 'Unknown';
              double price = order['price'] ?? 0.0;
              int quantity = order['quantity'] ?? 1;
              double totalPrice = price * quantity;

              return FutureBuilder<Map<String, dynamic>>(
                future: _getUserDetails(userEmail),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasError) {
                    print('Error fetching user details: ${userSnapshot.error}');
                    return Center(child: Text('Error fetching user details'));
                  }

                  var userDetails = userSnapshot.data ?? {};
                  String userName = userDetails['name'] ?? 'Unknown';
                  String userAddress = userDetails['address'] ?? 'Unknown';
                  String mobileNumber = userDetails['mobile'] ?? 'Unknown';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                            "User Name: $userName",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Pizza Name: $pizzaName",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Selected Size: $selectedSize",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Email: $userEmail",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Address: $userAddress",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Mobile Number: $mobileNumber",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Price: \$${price.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Quantity: $quantity",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total Price: \$${price.toStringAsFixed(2)} * $quantity = \$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                          _buildStatusRadio(
                              orderId, currentStatus, 'On The Way'),
                          _buildStatusRadio(
                              orderId, currentStatus, 'Delivered'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
