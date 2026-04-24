import 'package:flutter/material.dart';
import '../utils/download_service.dart';


class ProfileSubScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const ProfileSubScreen({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: child,
    );
  }
}

/// ─── ORDER HISTORY SCREEN ───
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Order History",
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) => _orderItem(index),
      ),
    );
  }

  Widget _orderItem(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B1C1C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.restaurant, color: Color(0xFF9B1C1C)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${1234 + index}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "25 March 2026 • Cafeteria 2",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Text(
                "Rs. 450",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF9B1C1C)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                // TODO: Add to cart logic
              },
              icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF9B1C1C), size: 18),
              label: const Text(
                "Order Again",
                style: TextStyle(color: Color(0xFF9B1C1C), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── PAYMENT METHODS ───
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Payment Methods",
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _paymentCard(Icons.credit_card, "Visa •••• 1310", "Expires 09/27"),
            const SizedBox(height: 15),
            _paymentCard(Icons.wallet, "Canteeno Wallet", "Balance: Rs. 500"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF9B1C1C)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add, color: Color(0xFF9B1C1C)),
                label: const Text("Add Payment Method", style: TextStyle(color: Color(0xFF9B1C1C))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9B1C1C)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF9B1C1C), size: 18),
        ],
      ),
    );
  }
}

/// ─── PAYMENT HISTORY ───
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Payment History",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20).copyWith(bottom: 0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B1C1C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  DownloadService.downloadReport(
                    context,
                    fileName: 'user_payment_history_${DateTime.now().toString().split(' ')[0]}',
                    reportType: 'User Payment History',
                    reportData: {
                      'Total Transactions': '4',
                      'Latest Transaction': '24 March 2026',
                      'Total Spent/Added': 'Rs. 2350',
                    },
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white, size: 20),
                label: const Text(
                  "Download to Desktop",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) => _paymentHistoryItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentHistoryItem(int index) {
    final bool isDebit = index % 2 == 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            isDebit ? Icons.arrow_outward : Icons.add_circle_outline,
            color: isDebit ? Colors.black : Colors.green,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isDebit ? "Food Purchase" : "Wallet Top-up", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("24 March 2026 • 12:45 PM", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text(
            isDebit ? "- Rs. 450" : "+ Rs. 1000",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDebit ? Colors.black : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── SAVED ADDRESSES ───
class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  // Mock data for addresses
  final List<Map<String, dynamic>> _addresses = [
    {
      "id": "1",
      "icon": Icons.home,
      "title": "Home",
      "subtitle": "123, Main Street, Colombo",
    },
    {
      "id": "2",
      "icon": Icons.school,
      "title": "SLIIT Campus",
      "subtitle": "New Academic Building, Floor 4",
    },
  ];

  void _showAddressModal({Map<String, dynamic>? addressInfo}) {
    final bool isEditing = addressInfo != null;
    final titleController = TextEditingController(text: isEditing ? addressInfo['title'] : "");
    final subtitleController = TextEditingController(text: isEditing ? addressInfo['subtitle'] : "");
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20, right: 20, top: 12,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Handle
                   Center(
                     child: Container(
                       width: 40, height: 4,
                       decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                     ),
                   ),
                   const SizedBox(height: 20),

                   // Title
                   Row(
                     children: [
                       Icon(isEditing ? Icons.edit_location_alt : Icons.add_circle_outline, color: const Color(0xFF9B1C1C), size: 24),
                       const SizedBox(width: 10),
                       Text(isEditing ? "Edit Address" : "Add New Address", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                     ],
                   ),
                   const SizedBox(height: 6),
                   Text(
                     isEditing ? "Update your address details below" : "Fill in the details to add a new address",
                     style: TextStyle(color: Colors.grey[600], fontSize: 13),
                   ),
                   const SizedBox(height: 24),

                   // Title Field
                   const Text("Title *", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                   const SizedBox(height: 6),
                   TextFormField(
                     controller: titleController,
                     decoration: InputDecoration(
                       hintText: "e.g. Home, Work",
                       prefixIcon: const Icon(Icons.label_outline, color: Color(0xFF9B1C1C)),
                       filled: true,
                       fillColor: const Color(0xFFF5F5F5),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                       contentPadding: const EdgeInsets.symmetric(vertical: 16),
                     ),
                     validator: (v) => v == null || v.trim().isEmpty ? "Title is required" : null,
                   ),
                   const SizedBox(height: 16),

                   // Address Field
                   const Text("Full Address *", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                   const SizedBox(height: 6),
                   TextFormField(
                     controller: subtitleController,
                     maxLines: 2,
                     decoration: InputDecoration(
                       hintText: "e.g. 123 Main Street, Colombo",
                       prefixIcon: const Padding(
                         padding: EdgeInsets.only(bottom: 24), // Center icon for multiline
                         child: Icon(Icons.location_on_outlined, color: Color(0xFF9B1C1C)),
                       ),
                       filled: true,
                       fillColor: const Color(0xFFF5F5F5),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                     ),
                     validator: (v) {
                       if (v == null || v.trim().isEmpty) return "Full Address is required";
                       if (v.trim().length < 10) return "Please enter a complete and descriptive address";
                       return null;
                     },
                   ),
                   const SizedBox(height: 28),

                   // Submit Button
                   SizedBox(
                     width: double.infinity, height: 52,
                     child: ElevatedButton.icon(
                       icon: Icon(isEditing ? Icons.save : Icons.add, color: Colors.white, size: 20),
                       label: Text(
                         isEditing ? "UPDATE ADDRESS" : "ADD ADDRESS",
                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                       ),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFF9B1C1C),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                         elevation: 0,
                       ),
                       onPressed: () {
                         if (!formKey.currentState!.validate()) return;
                         
                         setState(() {
                           if (isEditing) {
                             final index = _addresses.indexWhere((element) => element['id'] == addressInfo['id']);
                             if (index != -1) {
                               _addresses[index]['title'] = titleController.text.trim();
                               _addresses[index]['subtitle'] = subtitleController.text.trim();
                             }
                           } else {
                             _addresses.add({
                               "id": DateTime.now().millisecondsSinceEpoch.toString(),
                               "icon": Icons.location_on, // Map icon
                               "title": titleController.text.trim(),
                               "subtitle": subtitleController.text.trim(),
                             });
                           }
                         });
                         Navigator.pop(ctx);
                       },
                     ),
                   ),
                   const SizedBox(height: 10),

                   // Cancel Button
                   SizedBox(
                     width: double.infinity, height: 48,
                     child: OutlinedButton(
                       onPressed: () => Navigator.pop(ctx),
                       style: OutlinedButton.styleFrom(
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                         side: BorderSide(color: Colors.grey[300]!),
                       ),
                       child: const Text("CANCEL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 1)),
                     ),
                   ),
                   const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteAddress(String id) {
    setState(() {
      _addresses.removeWhere((element) => element['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Saved Addresses", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _addresses.isEmpty
          ? const Center(child: Text("No saved addresses yet."))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return _addressItem(address);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF9B1C1C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Address", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAddressModal(),
      ),
    );
  }

  Widget _addressItem(Map<String, dynamic> address) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(address['icon'], color: const Color(0xFF9B1C1C)),
        title: Text(address['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(address['subtitle']),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              _showAddressModal(addressInfo: address);
            } else if (value == 'delete') {
              _deleteAddress(address['id']);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: Colors.black),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─── NOTIFICATIONS SCREEN ───
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Notifications",
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _notificationItem(index),
      ),
    );
  }

  Widget _notificationItem(int index) {
    final titles = ["Order Ready!", "Bonus Points", "New Promotion"];
    final descriptions = [
      "Your order from Cafeteria 1 is ready for pick up.",
      "You earned 50 bonus points for your last purchase!",
      "Try the new spicy chicken combo at a 15% discount."
    ];
    final times = ["2 mins ago", "1 hour ago", "Yesterday"];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_active_outlined, color: Color(0xFF9B1C1C), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(descriptions[index], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 8),
                Text(times[index], style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── PRIVACY & SECURITY SCREEN ───
class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Privacy & Security",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingItem(Icons.lock_outline, "Change Password", "Update your account password"),
          _divider(),
          _settingItem(Icons.fingerprint, "Biometric Login", "Enable FaceID or Fingerprint", showToggle: true),
          _divider(),
          _settingItem(Icons.security, "Two-Factor Auth", "Highly recommended for safety", showToggle: false),
          _divider(),
          _settingItem(Icons.delete_outline, "Account Deletion", "This action is permanent", isDestructive: true),
        ],
      ),
    );
  }

  Widget _settingItem(IconData icon, String title, String subtitle, {bool showToggle = false, bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : const Color(0xFF9B1C1C)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDestructive ? Colors.red : Colors.black)),
      subtitle: Text(subtitle),
      trailing: showToggle ? Switch(value: true, onChanged: (v) {}, activeThumbColor: const Color(0xFF9B1C1C)) : const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey[200]);
}

/// ─── HELP & SUPPORT SCREEN ───
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Help & Support",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("How can we help you?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _helpCard(Icons.question_answer_outlined, "FAQs", "Common questions & solutions"),
          const SizedBox(height: 12),
          _helpCard(Icons.chat_bubble_outline, "Live Chat", "Our support agents are online"),
          const SizedBox(height: 12),
          _helpCard(Icons.mail_outline, "Contact Us", "Email us at support@canteeno.com"),
          const SizedBox(height: 30),
          const Text("Common Issues", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _faqItem("My order wasn't delivered"),
          _faqItem("Refund request process"),
          _faqItem("App technical problems"),
        ],
      ),
    );
  }

  Widget _helpCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9B1C1C)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ])),
        ],
      ),
    );
  }

  Widget _faqItem(String title) => ListTile(title: Text(title), trailing: const Icon(Icons.arrow_forward_ios, size: 14));
}

/// ─── ABOUT SCREEN ───
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "About",
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Image.asset('assets/logoHome.png', height: 100),
            const SizedBox(height: 20),
            const Text("Canteeno", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF9B1C1C))),
            const Text("Your Smart Campus Solution", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            const Text("Version 1.0.0", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _aboutLink("Terms of Service"),
            const Divider(),
            _aboutLink("Privacy Policy"),
            const Divider(),
            _aboutLink("Open Source Licenses"),
            const Spacer(),
            const Text("© 2026 Canteeno Team. All rights reserved.", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _aboutLink(String text) => ListTile(title: Text(text), trailing: const Icon(Icons.launch, size: 16));
}

/// ─── REWARDS SCREEN ───
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Rewards",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF9B1C1C), Color(0xFFC62828)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text("Your Points", style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 8),
                Text("120", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text("Redeem for free meals and drinks!", style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Badges Earned", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _badgeIcon(Icons.emoji_events, "Daily Eater", Colors.amber),
              _badgeIcon(Icons.local_pizza, "Pizza Lover", Colors.orange),
              _badgeIcon(Icons.coffee, "Active User", Colors.brown),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badgeIcon(IconData icon, String label, Color color) => Column(children: [
    CircleAvatar(radius: 30, backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 30)),
    const SizedBox(height: 8),
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
  ]);
}

/// ─── VOUCHERS SCREEN ───
class VouchersScreen extends StatelessWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Vouchers",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Voucher Code",
              suffixIcon: TextButton(onPressed: () {}, child: const Text("Apply", style: TextStyle(color: Color(0xFF9B1C1C), fontWeight: FontWeight.bold))),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF9B1C1C))),
            ),
          ),
          const SizedBox(height: 30),
          const Text("Available Vouchers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _voucherItem("20% OFF", "Valid on Cafeteria 2 lunch", "EXP 30-03-2026"),
          const SizedBox(height: 12),
          _voucherItem("FREE DRINK", "Buy 1 Main Get 1 Free Drink", "EXP 01-04-2026"),
        ],
      ),
    );
  }

  Widget _voucherItem(String title, String subtitle, String exp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF9B1C1C).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9B1C1C).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF9B1C1C))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(exp, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ),
    );
  }
}

/// ─── FAVORITES SCREEN ───
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: "Favorites",
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) => _favItem(index),
      ),
    );
  }

  Widget _favItem(int index) {
    final names = ["Creamy Sausage Pasta", "Chicken & Rice", "Spicy Koththu"];
    final images = ["assets/food/sausage_pasta.jpeg", "assets/food/chicken_rice.jpeg", "assets/food/koththu.jpeg"];
    final prices = ["850", "800", "650"];
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(images[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Cafeteria ${index + 1}"),
      trailing: Text("Rs. ${prices[index]}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9B1C1C))),
    );
  }
}

/// ─── GENERIC MOCK SCREEN ───
class MockScreen extends StatelessWidget {
  final String title;
  const MockScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ProfileSubScreen(
      title: title,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              "$title is currently under development",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

