import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/admin/add_pizza.dart';
import 'package:pizza_delivery_app/admin/view_pizza.dart';
import 'package:pizza_delivery_app/order_management/order_approve.dart';
import 'package:pizza_delivery_app/user/menu_screen.dart';
import 'package:pizza_delivery_app/user/account_info.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AddPizzaPage(),
    ViewPizzaPage(),
    OrderApprovePage(),
    AccountInfoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pizza_rounded),
            label: 'Add Pizza',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'View Foods',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Order Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
