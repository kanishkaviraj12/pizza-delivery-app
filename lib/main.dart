import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/admin/add_pizza.dart';
import 'package:pizza_delivery_app/admin/admin_home.dart';
import 'package:pizza_delivery_app/firebase_options.dart';
import 'package:pizza_delivery_app/user/menu_screen.dart';
import 'package:pizza_delivery_app/user/pizza_detail_page.dart';
import 'package:pizza_delivery_app/user/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner
      title: 'Pizza Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: //dminHomePage(),
          UserHomePage(),
    );
  }
}
