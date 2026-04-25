import 'package:flutter/material.dart';

class PromotionsPage extends StatelessWidget {
  const PromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text(
          "Promotions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _promoCard(
            title: "20% Off Lunch Combo",
            description: "Get 20% off on any lunch combo meal. Valid until end of month.",
            icon: Icons.local_offer,
          ),
          _promoCard(
            title: "Free Drink Friday",
            description: "Order any main course on Friday and get a free drink!",
            icon: Icons.local_drink,
          ),
          _promoCard(
            title: "Student Special",
            description: "Show your student ID for a 15% discount on all items.",
            icon: Icons.school,
          ),
        ],
      ),
    );
  }

  Widget _promoCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF8B0000),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(description),
        ),
      ),
    );
  }
}

