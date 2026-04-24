import 'package:flutter/material.dart';

class PaymentListPage extends StatelessWidget {
  const PaymentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> payments = [
      {'id': '#001', 'user': 'Aisha Nafy', 'amount': 'Rs. 450', 'status': 'Completed'},
      {'id': '#002', 'user': 'John Doe', 'amount': 'Rs. 500', 'status': 'Pending'},
      {'id': '#003', 'user': 'Jane Smith', 'amount': 'Rs. 1050', 'status': 'Completed'},
      {'id': '#004', 'user': 'Kumar P.', 'amount': 'Rs. 350', 'status': 'Failed'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Management'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          Color statusColor;
          switch (payment['status']) {
            case 'Completed':
              statusColor = Colors.green;
              break;
            case 'Pending':
              statusColor = Colors.orange;
              break;
            default:
              statusColor = Colors.red;
          }

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
                child: Icon(Icons.payment, color: Colors.white),
              ),
              title: Text(
                '${payment['user']} - ${payment['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(payment['amount']!),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  payment['status']!,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

