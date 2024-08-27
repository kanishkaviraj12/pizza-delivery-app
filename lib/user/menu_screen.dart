import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final List<Map<String, dynamic>> pizzas = [
    {
      'name': 'Spinach Delight',
      'price': 90.00,
      'image': 'assets/pizza_0.png',
      'description': 'Pizza magic: create, bake, savor perfection!',
      'isSpicy': true,
      'isNonVeg': false,
      'originalPrice': 95.00,
    },
    {
      'name': 'Cheesy Marvel',
      'price': 70.00,
      'image': 'assets/pizza_1.png',
      'description': 'Crafting joy: your rules, best taste!',
      'isSpicy': false,
      'isNonVeg': false,
      'originalPrice': 80.00,
    },
    {
      'name': 'Pepperoni Bliss',
      'price': 60.00,
      'image': 'assets/pizza_2.png',
      'description': 'Unleash flavor: build your dream pizza!',
      'isSpicy': false,
      'isNonVeg': true,
      'originalPrice': 70.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Menu'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: pizzas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2 / 3, // Adjust this ratio if needed
        ),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              // Added SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pizza Image
                  Image.asset(
                    pizzas[index]['image'],
                    height: 120,
                    width: double.infinity,
                    //fit: BoxFit.contain,
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
                              Badge(label: 'Non-Veg', color: Colors.red),
                            if (pizzas[index]['isSpicy'])
                              Badge(label: 'Spicy', color: Colors.orange),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          );
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
