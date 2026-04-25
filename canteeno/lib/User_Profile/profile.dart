import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'promotions.dart';
import 'manage_account.dart';
import 'help.dart';
import 'about.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      /// 🔻 APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      /// 🔻 BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔹 PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: const Color(0xFF8B0000),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/profile.jpg',
                    ), // replace with user's profile image
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Aisha Nafy", // nickname
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "+94 77 123 4567", // phone number
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 HORIZONTAL CARDS (Wallet, Orders, Rewards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  horizontalCard(
                    Icons.account_balance_wallet,
                    "Wallet",
                    "Rs. 5000",
                    context,
                  ),
                  horizontalCard(Icons.history, "Orders", "25 Orders", context),
                  horizontalCard(Icons.star, "Rewards", "120 Points", context),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 VERTICAL CARDS
            verticalCard(Icons.local_offer, "Promotions", context),
            verticalCard(Icons.manage_accounts, "Manage Account", context),
            verticalCard(Icons.help_outline, "Help", context),
            verticalCard(Icons.info_outline, "About", context),
          ],
        ),
      ),
    );
  }

  /// 🔹 HORIZONTAL CARD
  Widget horizontalCard(
    IconData icon,
    String title,
    String subtitle,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == "Wallet") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WalletScreen()),
          );
        }

        if (title == "Orders") {
          // TODO: Navigate to OrdersScreen
        }

        if (title == "Rewards") {
          // TODO: Navigate to RewardsScreen
        }
      },
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 VERTICAL CARD
  Widget verticalCard(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: Colors.red),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            if (title == "Promotions") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PromotionsPage()),
              );
            } else if (title == "Manage Account") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageAccount()),
              );
            } else if (title == "Help") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            } else if (title == "About") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            }
          },
        ),
      ),
    );
  }
}

