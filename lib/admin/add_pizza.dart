import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPizzaPage extends StatefulWidget {
  const AddPizzaPage({super.key});

  @override
  _AddPizzaPageState createState() => _AddPizzaPageState();
}

class _AddPizzaPageState extends State<AddPizzaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _badge = 'spicy';
  File? _imageFile;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("pizza_images/${DateTime.now()}.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> addPizzaToFirestore(String name, String description,
      double price, String imageUrl, String badge) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('pizzas').add({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'badge': badge,
    });
  }

  Future<void> submitPizzaData() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      String imageUrl = await uploadImageToFirebase(_imageFile!);
      await addPizzaToFirestore(
        _nameController.text,
        _descriptionController.text,
        double.parse(_priceController.text),
        imageUrl,
        _badge,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pizza added successfully!')));
      _formKey.currentState!.reset();
      setState(() {
        _imageFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please complete the form and select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pizza'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Pizza Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pizza name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _badge,
                items: ['spicy', 'non-veg'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _badge = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Badge'),
              ),
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!,
                      height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 100)),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitPizzaData,
                child: const Text('Add Pizza'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
