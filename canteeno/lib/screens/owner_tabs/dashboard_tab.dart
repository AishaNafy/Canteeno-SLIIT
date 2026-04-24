import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/food_provider.dart';
import '../../utils/download_service.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodProvider>(
      builder: (context, provider, child) {
        int total = provider.foodItems.length;
        int inStock = provider.foodItems
            .where((i) => i.stockStatus == StockStatus.inStock)
            .length;
        int limited = provider.foodItems
            .where((i) => i.stockStatus == StockStatus.limitedStock)
            .length;
        int outOfStock = provider.foodItems
            .where((i) => i.stockStatus == StockStatus.outOfStock)
            .length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF9B1C1C), Color(0xFFB71C1C)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome Back! 👋",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Canteen Owner Dashboard",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _downloadDashboardReport(
                            context, inStock, limited, outOfStock, total);
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label:
                          const Text('Report', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF9B1C1C),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Stats Grid
              Row(
                children: [
                  _card("Total Items", "$total", Icons.restaurant_menu,
                      const Color(0xFF008080)),
                  const SizedBox(width: 10),
                  _card(
                      "In Stock", "$inStock", Icons.check_circle, Colors.green),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _card("Limited", "$limited", Icons.warning_amber,
                      Colors.orange),
                  const SizedBox(width: 10),
                  _card(
                      "Out of Stock", "$outOfStock", Icons.cancel, Colors.red),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _card("Orders Today", "45", Icons.shopping_bag,
                      const Color(0xFF1565C0)),
                  const SizedBox(width: 10),
                  _card("Revenue", "Rs. 5,250", Icons.attach_money,
                      const Color(0xFF7B1FA2)),
                ],
              ),
              const SizedBox(height: 24),

              /// Recent Activity
              const Row(
                children: [
                  Icon(Icons.history, color: Color(0xFF9B1C1C), size: 22),
                  SizedBox(width: 8),
                  Text("Recent Activity",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              _activityItem("New order #106 from Sarah K.", "2 min ago",
                  Icons.shopping_cart, Colors.blue),
              _activityItem("Spicy Chicken Wrap marked as Limited",
                  "15 min ago", Icons.warning_amber, Colors.orange),
              _activityItem("Payment received Rs. 850", "30 min ago",
                  Icons.payment, Colors.green),
              _activityItem("New menu item added: Pasta", "1 hour ago",
                  Icons.add_circle, const Color(0xFF008080)),
              _activityItem("Order #102 completed", "2 hours ago",
                  Icons.check_circle, Colors.green),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _downloadDashboardReport(BuildContext context,
      int inStock, int limited, int outOfStock, int total) async {
    await DownloadService.downloadReport(
      context,
      fileName: 'dashboard_report_${DateTime.now().toString().split(' ')[0]}',
      reportType: 'Dashboard Summary',
      reportData: {
        'Total Items': total,
        'In Stock': inStock,
        'Limited Stock': limited,
        'Out of Stock': outOfStock,
        'Orders Today': '45',
        'Revenue': 'Rs. 5,250',
        'Generated Date': DateTime.now().toString(),
      },
    );
  }

  static Widget _card(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _activityItem(
      String text, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500))),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
        ],
      ),
    );
  }
}
