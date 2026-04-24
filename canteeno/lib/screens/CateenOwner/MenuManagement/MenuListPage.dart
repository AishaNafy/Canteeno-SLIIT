import 'package:flutter/material.dart';

class MenuListPage extends StatelessWidget {
  const MenuListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'name': 'Chicken Rice', 'price': 'Rs. 450', 'available': true},
      {'name': 'Fried Rice', 'price': 'Rs. 500', 'available': true},
      {'name': 'Kottu', 'price': 'Rs. 550', 'available': true},
      {'name': 'Burger', 'price': 'Rs. 400', 'available': false},
      {'name': 'Pizza Slice', 'price': 'Rs. 350', 'available': true},
      {'name': 'Noodles', 'price': 'Rs. 480', 'available': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B0000),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF8B0000),
                child: Icon(Icons.restaurant, color: Colors.white),
              ),
              title: Text(
                item['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(item['price']),
              trailing: Switch(
                value: item['available'],
                activeThumbColor: const Color(0xFF8B0000),
                onChanged: (val) {},
              ),
            ),
          );
        },
      ),
    );
  }
}

