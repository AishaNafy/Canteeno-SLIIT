import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  final List<Map<String, String>> transactions = const [
    {"title": "Order #1234", "date": "2026-03-25", "amount": "-LKR 500"},
    {"title": "Top-up", "date": "2026-03-24", "amount": "+LKR 1000"},
    {"title": "Voucher Applied", "date": "2026-03-23", "amount": "-LKR 200"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: Colors.red.shade900,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(tx["title"]!),
              subtitle: Text(tx["date"]!),
              trailing: Text(
                tx["amount"]!,
                style: TextStyle(
                  color: tx["amount"]!.startsWith("+")
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

