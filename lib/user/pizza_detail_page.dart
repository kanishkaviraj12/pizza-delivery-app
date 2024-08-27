import 'package:flutter/material.dart';

class PizzaDetailsPage extends StatefulWidget {
  final String pizzaName;
  final String description;
  final String imageUrl;
  final double price;

  const PizzaDetailsPage({
    super.key,
    required this.pizzaName,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  @override
  _PizzaDetailsPageState createState() => _PizzaDetailsPageState();
}

class _PizzaDetailsPageState extends State<PizzaDetailsPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedSize = 'M'; // Default size

  // Define size constants for pizza image
  final Map<String, double> _sizeMap = {
    'S': 200.0,
    'M': 250.0,
    'L': 300.0,
  };

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(); // Initial animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pizzaName),
        //backgroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Full-circle Background aligned to the top
          Positioned(
            top: -150, // Adjust this value to control vertical positioning
            left: -50, // Adjust this value to control horizontal positioning
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(0.2),
              ),
            ),
          ),
          // Use RotationTransition and ScaleTransition to animate image
          Positioned(
            top: 16, // Position from top
            left: MediaQuery.of(context).size.width / 2 -
                (_sizeMap[_selectedSize]! / 2), // Center horizontally
            child: RotationTransition(
              turns: _rotationAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: _sizeMap[_selectedSize],
                  height: _sizeMap[_selectedSize],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Align the rest of the content to the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Ensures Column takes only needed space
                children: [
                  // Pizza Name
                  Text(
                    widget.pizzaName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Pizza Description
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pizza Size Selection
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSizeOption('S'),
                      _buildSizeOption('M'),
                      _buildSizeOption('L'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Quantity and Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Quantity Selector
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                color: Colors.orange,
                                onPressed: _quantity > 1
                                    ? () {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    : null,
                              ),
                              Text(
                                _quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.orange,
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                          Spacer(),
                          // Price
                          Text(
                            'Price: \$${(widget.price * _quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Buy Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle buy action
                      },
                      child: Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;

          // Update the animations
          _scaleAnimation = Tween<double>(
            begin: _scaleAnimation.value,
            end: _sizeMap[size]! / _sizeMap[_selectedSize]!,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );

          _rotationAnimation = Tween<double>(
            begin: _rotationAnimation.value,
            end: _rotationAnimation.value + 0.06, // Rotates 180 degrees
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );

          _animationController.forward(from: 0.0); // Reset animation
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: _selectedSize == size ? Colors.orange : Colors.grey[200],
        ),
        child: Text(
          size,
          style: TextStyle(
            fontSize: 16,
            color: _selectedSize == size ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
