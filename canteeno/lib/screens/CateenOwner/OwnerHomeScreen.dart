import 'package:flutter/material.dart';
import 'MenuManagement/MenuListPage.dart';
import 'PaymentManagement/PaymentListPage.dart';
import 'Reports/SalesReportPage.dart';
import 'Reports/OwnerProfilePage.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OwnerProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _dashboardCard(
            context,
            'Menu',
            Icons.restaurant_menu,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuListPage()),
            ),
          ),
          _dashboardCard(
            context,
            'Payments',
            Icons.payment,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaymentListPage()),
            ),
          ),
          _dashboardCard(
            context,
            'Reports',
            Icons.bar_chart,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SalesReportPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.red),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

