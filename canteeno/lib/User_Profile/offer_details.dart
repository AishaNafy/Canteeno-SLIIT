import 'package:flutter/material.dart';

class OfferDetailsScreen extends StatelessWidget {
  final String title;
  final String description;

  const OfferDetailsScreen({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offer Details"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: apply offer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Offer Applied!")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Apply Offer"),
            ),
          ],
        ),
      ),
    );
  }
}
