import 'package:flutter/material.dart';

class OwnerProfilePage extends StatelessWidget {
  const OwnerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Profile'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: const Color(0xFF8B0000),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Color(0xFF8B0000)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Canteen Owner",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "owner@canteeno.com",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _profileTile(Icons.store, "Canteen Name", "Main Campus Canteen"),
            _profileTile(Icons.location_on, "Location", "Building A, Ground Floor"),
            _profileTile(Icons.access_time, "Operating Hours", "7:00 AM - 8:00 PM"),
            _profileTile(Icons.phone, "Contact", "+94 11 234 5678"),
            _profileTile(Icons.settings, "Settings", "Manage preferences"),
            _profileTile(Icons.logout, "Logout", "Sign out of your account"),
          ],
        ),
      ),
    );
  }

  static Widget _profileTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8B0000)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

