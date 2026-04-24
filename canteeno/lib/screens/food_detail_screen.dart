import 'package:flutter/material.dart';

class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Massive Image
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.food["image"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Content Pane (Like Mockup Screen 2)
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.food["name"],
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.food["weight"],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.food["price"],
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9B1C1C),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        
                        const SizedBox(height: 35),
                        
                        // Ingredients Section
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ingredients",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54)
                          ],
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildIngredient("🧀", "Cheese", true),
                              const SizedBox(width: 20),
                              _buildIngredient("🥬", "Vegetables", false),
                              const SizedBox(width: 20),
                              _buildIngredient("🥩", "Meat", false),
                              const SizedBox(width: 20),
                              _buildIngredient("🍅", "Tomato", false),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Customizations (Mockup Screen 3 style checkboxes/adders)
                        _buildCustomizationRow("Gouda", "\$0.5"),
                        _buildCustomizationRow("Emmental", "\$0.15"),
                        _buildCustomizationRow("Cheddar", "\$0.25"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          
          // Fixed Bottom Add to Cart Action
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -5),
                    blurRadius: 10,
                  )
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9B1C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added $quantity to Cart!')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIngredient(String emoji, String name, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF9B1C1C) : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color(0xFF9B1C1C).withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
            ]
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 28)),
        ),
        const SizedBox(height: 10),
        Text(
          name, 
          style: TextStyle(
            fontSize: 13, 
            color: isSelected ? const Color(0xFF9B1C1C) : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationRow(String name, String extraPrice) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(extraPrice, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.remove, size: 16, color: Colors.black54),
              ),
              const SizedBox(width: 20),
              const Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 20),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }
}

