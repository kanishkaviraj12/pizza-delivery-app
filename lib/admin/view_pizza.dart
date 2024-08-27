import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_delivery_app/admin/update_pizza.dart';

class ViewPizzaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pizzas')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pizzas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pizzas found.'));
          } else {
            final pizzas = snapshot.data!.docs;
            return ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzas[index];
                return ListTile(
                  title: Text(pizza['name']),
                  subtitle: Text(pizza['description']),
                  leading: Image.network(pizza['imageUrl']),
                  trailing: Text('\$${pizza['price']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdatePizzaPage(pizzaId: pizza.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
