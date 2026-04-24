import 'package:flutter/material.dart';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _summaryCard('Today\'s Sales', 'Rs. 12,500', Icons.today),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard('This Week', 'Rs. 85,000', Icons.calendar_view_week),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _summaryCard('Total Orders', '156', Icons.receipt_long),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard('Avg. Order', 'Rs. 545', Icons.analytics),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Top Selling Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _topItemTile('Chicken Rice', '45 orders', 1),
            _topItemTile('Fried Rice', '38 orders', 2),
            _topItemTile('Kottu', '32 orders', 3),
            _topItemTile('Noodles', '28 orders', 4),
            _topItemTile('Burger', '22 orders', 5),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF8B0000), size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _topItemTile(String name, String orders, int rank) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF8B0000),
          child: Text(
            '#$rank',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(orders, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

