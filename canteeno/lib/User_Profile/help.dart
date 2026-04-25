import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text(
          "Help",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _helpTile(
            icon: Icons.question_answer,
            title: "FAQs",
            subtitle: "Find answers to common questions",
          ),
          _helpTile(
            icon: Icons.email,
            title: "Contact Us",
            subtitle: "support@canteeno.com",
          ),
          _helpTile(
            icon: Icons.phone,
            title: "Call Support",
            subtitle: "+94 11 234 5678",
          ),
          _helpTile(
            icon: Icons.feedback,
            title: "Send Feedback",
            subtitle: "Help us improve your experience",
          ),
          _helpTile(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            subtitle: "Read our privacy policy",
          ),
          _helpTile(
            icon: Icons.description,
            title: "Terms of Service",
            subtitle: "Review terms and conditions",
          ),
        ],
      ),
    );
  }

  Widget _helpTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8B0000)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

