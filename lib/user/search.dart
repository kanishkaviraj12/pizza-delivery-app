import 'package:flutter/material.dart';

class SearchFilterScreen extends StatefulWidget {
  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';
  final List<Map<String, dynamic>> pizzas = [
    {'name': 'Pepperoni Pizza', 'category': 'Non-Veg', 'price': 9.99},
    {'name': 'Margherita Pizza', 'category': 'Veg', 'price': 8.99},
    {'name': 'BBQ Chicken Pizza', 'category': 'Non-Veg', 'price': 10.99},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search & Filter'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField(
              value: selectedCategory,
              items: ['All', 'Veg', 'Non-Veg'].map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                if ((searchQuery.isEmpty ||
                        pizzas[index]['name']
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase())) &&
                    (selectedCategory == 'All' ||
                        pizzas[index]['category'] == selectedCategory)) {
                  return ListTile(
                    title: Text(pizzas[index]['name']),
                    subtitle: Text(pizzas[index]['category']),
                    trailing: Text('\$${pizzas[index]['price']}'),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
