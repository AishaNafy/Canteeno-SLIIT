import 'package:flutter/material.dart';
import 'add_payment.dart';
import 'add_voucher.dart';
import 'offer_details.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// 🔹 AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      /// 🔹 Body
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Uber Cash Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Uber Cash", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                        "LKR 0.00",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),

            /// 🔹 Payment Methods
            _sectionTitle("Payment methods"),

            _listTile(icon: Icons.credit_card, title: "Visa ••••1310"),

            _listTile(icon: Icons.attach_money, title: "Cash"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate to add_payment.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add payment method"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Vouchers
            _sectionTitle("Vouchers"),

            _listTile(
              icon: Icons.confirmation_num_outlined,
              title: "Vouchers",
              trailing: "0",
            ),

            _listTile(
              icon: Icons.add,
              title: "Add voucher code",
              onTap: () {
                // Navigate to add_voucher.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddVoucherScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            /// 🔹 In-Store Offers
            _sectionTitle("In-Store Offers"),

            _listTile(
              icon: Icons.local_offer_outlined,
              title: "Offers",
              onTap: () {
                // Navigate to offer_details.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OfferDetailsScreen(
                      title: "Special Offer",
                      description: "Get 20% off on your next purchase!",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      /// 🔹 Bottom Navigation
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: null, icon: Icon(Icons.home_outlined)),

            IconButton(onPressed: null, icon: Icon(Icons.location_on_outlined)),

            /// 🔹 Search Bar
            IconButton(onPressed: null, icon: Icon(Icons.search)),

            IconButton(
              onPressed: null,
              icon: Icon(Icons.shopping_cart_outlined),
            ),

            IconButton(onPressed: null, icon: Icon(Icons.person_outline)),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 🔹 Reusable ListTile
  Widget _listTile({
    required IconData icon,
    required String title,
    String? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title),
      trailing: trailing != null
          ? Text(trailing)
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

