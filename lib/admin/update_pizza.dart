import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UpdatePizzaPage extends StatefulWidget {
  final String pizzaId;

  UpdatePizzaPage({required this.pizzaId});

  @override
  _UpdatePizzaPageState createState() => _UpdatePizzaPageState();
}

class _UpdatePizzaPageState extends State<UpdatePizzaPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadPizzaData();
  }

  Future<void> _loadPizzaData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('pizzas')
        .doc(widget.pizzaId)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    setState(() {
      _nameController.text = data['name'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _badgeController.text = data['badge'] ?? '';
      _priceController.text = data['price'].toString();
      _imageUrl = data['imageUrl'] ?? '';
    });
  }

  Future<void> _updatePizza() async {
    String imageUrl = _imageUrl ?? '';

    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pizza_images/${widget.pizzaId}.jpg');

      await storageRef.putFile(_selectedImage!);
      imageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection('pizzas')
        .doc(widget.pizzaId)
        .update({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'badge': _badgeController.text,
      'price': double.parse(_priceController.text),
      'imageUrl': imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pizza updated successfully')),
    );

    Navigator.pop(context); // Go back to the pizza list after updating
  }

  Future<void> _deletePizza() async {
    await FirebaseFirestore.instance
        .collection('pizzas')
        .doc(widget.pizzaId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pizza deleted successfully')),
    );

    Navigator.pop(context); // Go back to the pizza list after deletion
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageUrl = null; // Clear existing URL if a new image is selected
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Pizza',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Pizza Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _badgeController,
              decoration: const InputDecoration(labelText: 'Badge'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            _selectedImage == null && _imageUrl != null
                ? Image.network(
                    _imageUrl!,
                    height: 200,
                  )
                : _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 200,
                      )
                    : Container(height: 200, color: Colors.grey[200]),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 75, vertical: 10),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white),
                child: const Text('Pick Image'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updatePizza,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 75, vertical: 10),
                        textStyle: const TextStyle(fontSize: 18),
                        foregroundColor: Colors.white),
                    child: const Text('Update'),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _deletePizza,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        textStyle: const TextStyle(fontSize: 18),
                        foregroundColor: Colors.white),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
