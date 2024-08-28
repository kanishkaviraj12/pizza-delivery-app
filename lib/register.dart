import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _mobileNumber = '';
  String _address = '';
  String _selectedImage = 'dp_3.png'; // Initial default image
  final List<String> _imageOptions = [
    'dp_1.png',
    'dp_2.png',
    'dp_3.png',
    'dp_4.png',
    'dp_5.png',
    'dp_6.png'
  ];
  int _currentImageIndex = 0;
  final String _userType = 'user'; // Default user type

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildProfileImageSelector(),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
                onSaved: (value) => _mobileNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      foregroundColor: Colors.white),
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _currentImageIndex =
                  (_currentImageIndex + 1) % _imageOptions.length;
              _selectedImage = _imageOptions[_currentImageIndex];
            });
          },
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile_pic/$_selectedImage'),
            radius: 100,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tap to change image',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Hash the password before storing
        String hashedPassword = _hashPassword(_password);

        // Save additional user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _name,
          'userEmail': _email,
          'hashedPassword': hashedPassword,
          'mobile': _mobileNumber,
          'address': _address,
          'profileImage': _selectedImage,
          'userType': _userType, // Save user type
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully!')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register user: ${e.message}')),
        );
      }
    }
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
