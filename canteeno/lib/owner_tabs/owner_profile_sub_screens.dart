import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────
/// REUSABLE LOGIC FOR OWNER PROFILE SUB-SCREENS
/// ─────────────────────────────────────────────────
class OwnerProfileSubScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const OwnerProfileSubScreen({super.key, required this.title, required this.child});

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

/// ─── BUSINESS DETAILS ───
class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Business Details",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Cafeteria Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _infoField("Cafeteria Name", "Cafeteria 1"),
          const SizedBox(height: 15),
          _infoField("Business Registration", "BR-987654321"),
          const SizedBox(height: 15),
          _infoField("Operating Hours", "08:00 AM - 08:00 PM"),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text("Request Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}

/// ─── MANAGE STAFF ───
class OwnerManageStaffScreen extends StatelessWidget {
  const OwnerManageStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Manage Staff",
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final names = ["Kamal Perera", "Nilantha Silva", "Nuwan Kumara"];
          final roles = ["Manager", "Cashier", "Chef"];
          return ListTile(
            tileColor: Colors.grey[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF008080).withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: Color(0xFF008080)),
            ),
            title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(roles[index]),
            trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () {}),
          );
        },
      ),
    );
  }
}

/// ─── REPORTS & ANALYTICS ───
class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Reports & Analytics",
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text("Total Revenue (This Month)", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 10),
                  Text("Rs. 450,000", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart, size: 80, color: Colors.grey),
                    SizedBox(height: 15),
                    Text("Detailed charts will be available soon.", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─── BANK ACCOUNTS ───
class BankAccountsScreen extends StatelessWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Bank Accounts",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: Color(0xFF008080), size: 30),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Commercial Bank", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("**** **** **** 1234", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Primary", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            icon: const Icon(Icons.add, color: Color(0xFF008080)),
            label: const Text("Add New Bank Account", style: TextStyle(color: Color(0xFF008080))),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFF008080)),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

/// ─── NOTIFICATIONS (OWNER) ───
class OwnerNotificationsScreen extends StatelessWidget {
  const OwnerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Notifications",
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final msgs = [
            "New large order received (Rs. 12,500)",
            "Inventory alert: Garlic Naan low on stock",
            "Weekly payout processed to bank account",
            "New admin notice: Routine inspection tomorrow"
          ];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: Color(0xFF008080)),
                const SizedBox(width: 15),
                Expanded(child: Text(msgs[index], style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ─── SECURITY ───
class OwnerSecurityScreen extends StatelessWidget {
  const OwnerSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Security",
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            title: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text("Two-Factor Authentication", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Currently Disabled"),
            trailing: Switch(
              value: false,
              activeThumbColor: const Color(0xFF008080),
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── OWNER SUPPORT ───
class OwnerSupportScreen extends StatelessWidget {
  const OwnerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OwnerProfileSubScreen(
      title: "Owner Support",
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.support_agent, size: 80, color: Color(0xFF008080)),
            const SizedBox(height: 20),
            const Text(
              "Need Help with your Canteen?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Contact Canteeno administration directly for any menu, pricing, or system issues.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.email, color: Colors.white),
              label: const Text("Email Support", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              icon: const Icon(Icons.phone, color: Color(0xFF008080)),
              label: const Text("Call Admin Desk", style: TextStyle(color: Color(0xFF008080))),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: Color(0xFF008080)),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

