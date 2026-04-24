import 'package:flutter/material.dart';
import 'owner_profile_sub_screens.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  bool _isEditing = false;
  
  final TextEditingController _nameController = TextEditingController(text: "Aisha");
  final TextEditingController _emailController = TextEditingController(text: "aisha@canteeno.com");
  final TextEditingController _phoneController = TextEditingController(text: "+94 77 987 6543");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ─── PROFILE HEADER ───
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                  child: Column(
                    children: [
                      // Top row with back button and edit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                            ),
                          ),
                          const Text(
                            "Owner Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isEditing = !_isEditing;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isEditing ? const Color(0xFF008080) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _isEditing ? Icons.close : Icons.edit,
                                  color: _isEditing ? Colors.white : Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Profile Photo
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF008080),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF008080).withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const ClipOval(
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF008080),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Profile Info or Edit Form
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isEditing ? _buildEditForm() : _buildProfileInfo(),
                      ),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statCard("1,245", "Total Orders"),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          _statCard("Rs. 1.2M", "Revenue"),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          _statCard("4.8 ★", "Rating"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ─── MENU ITEMS ───
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _menuItem(Icons.storefront_outlined, "Business Details", "Update Canteen Info", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessDetailsScreen()))),
                  _divider(),
                  _menuItem(Icons.group_outlined, "Manage Staff", "Add or remove employees", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerManageStaffScreen()))),
                  _divider(),
                  _menuItem(Icons.bar_chart_outlined, "Reports & Analytics", "View sales performance", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen()))),
                  _divider(),
                  _menuItem(Icons.payment_outlined, "Bank Accounts", "Manage payout methods", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BankAccountsScreen()))),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ─── SETTINGS ───
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _menuItem(Icons.notifications_outlined, "Notifications", "Manage order alerts", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerNotificationsScreen()))),
                  _divider(),
                  _menuItem(Icons.security, "Security", "Password & 2FA", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerSecurityScreen()))),
                  _divider(),
                  _menuItem(Icons.help_outline, "Owner Support", "Contact Canteeno Admins", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerSupportScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ─── PROFILE INFO TEXT COMPONENT ───
  Widget _buildProfileInfo() {
    return Column(
      key: const ValueKey("info"),
      children: [
        Text(
          _nameController.text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Canteen Owner • Cafeteria 1",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${_emailController.text} • ${_phoneController.text}",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// ─── INLINE EDIT FORM COMPONENT ───
  Widget _buildEditForm() {
    return Container(
      key: const ValueKey("form"),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const Text(
            "Update Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF008080)),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration("Full Name", Icons.person_outline),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration("Email Address", Icons.email_outlined),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration("Phone Number", Icons.phone_outlined),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Profile updated successfully!"),
                      ],
                    ),
                    backgroundColor: Colors.green[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF008080)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF008080), width: 2),
      ),
    );
  }

  /// ─── STAT CARD ───
  Widget _statCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF008080),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// ─── MENU ITEM ───
  Widget _menuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF008080), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  /// ─── DIVIDER ───
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey[100]),
    );
  }
}

