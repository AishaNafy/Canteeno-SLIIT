import 'package:flutter/material.dart';

class PaymentMethodDetails extends StatelessWidget {
  final String title;
  final String details;

  const PaymentMethodDetails({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(details),
              subtitle: const Text("Payment method details"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: update backend
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment method updated")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Edit"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: delete backend
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment method deleted")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
