import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/user/pizza_detail_page.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchPizzas() async {
    QuerySnapshot querySnapshot = await firestore.collection('pizzas').get();
    return querySnapshot.docs.map((doc) {
      return {
        'name': doc['name'],
        'price': doc['price'],
        'imageUrl': doc['imageUrl'], // Updated to use imageUrl from Firestore
        'description': doc['description'],
        'isSpicy': doc['badge'] == 'spicy',
        'isNonVeg': doc['badge'] == 'non-veg',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Menu'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPizzas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading pizzas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pizzas available'));
          } else {
            final pizzas = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: pizzas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PizzaDetailsPage(
                            pizzaName: pizzas[index]['name'],
                            description: pizzas[index]['description'],
                            imageUrl: pizzas[index]['imageUrl'],
                            price: pizzas[index]['price'],
                          ),
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pizza Image
                          Image.network(
                            pizzas[index]['imageUrl'],
                            height: 120,
                            width: double.infinity,
                            //fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row with Badges
                                Row(
                                  children: [
                                    if (pizzas[index]['isNonVeg'])
                                      Badge(
                                          label: 'Non-Veg', color: Colors.red),
                                    if (pizzas[index]['isSpicy'])
                                      Badge(
                                          label: 'Spicy', color: Colors.orange),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Pizza Name
                                Text(
                                  pizzas[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Pizza Description
                                Text(
                                  pizzas[index]['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Row with Price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${pizzas[index]['price'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Badge Widget
class Badge extends StatelessWidget {
  final String label;
  final Color color;

  Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
