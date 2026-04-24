import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'owner_tabs/dashboard_tab.dart';
import 'owner_tabs/menu_tab.dart';
import 'owner_tabs/queue_tab.dart';
import 'owner_tabs/payments_tab.dart';
import 'owner_tabs/owner_profile_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});
  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<MenuTabState> _menuKey = GlobalKey<MenuTabState>();

  late final List<Widget> _pages = [
    const DashboardTab(),
    MenuTab(key: _menuKey),
    const QueueTab(),
    const PaymentsTab(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Menu Management",
    "Queue Management",
    "Payments",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      /// ─── APP BAR ───
      appBar: AppBar(
        backgroundColor: const Color(0xFF9B1C1C),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[_currentIndex],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "OWNER CONSOLE",
              style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OwnerProfileScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Row(children: [Icon(Icons.person_outline, color: Color(0xFF9B1C1C)), SizedBox(width: 10), Text('Profile')])),
              const PopupMenuItem(value: 'settings', child: Row(children: [Icon(Icons.settings_outlined, color: Color(0xFF9B1C1C)), SizedBox(width: 10), Text('Settings')])),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Row(children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 10), Text('Logout', style: TextStyle(color: Colors.red))])),
            ],
          ),
        ],
      ),

      /// ─── BODY ───
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),

      /// ─── FLOATING ACTION BUTTON (Menu tab only) ───
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                _menuKey.currentState?.openAddItemForm();
              },
              backgroundColor: const Color(0xFF008080),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,

      /// ─── BOTTOM NAVIGATION BAR ───
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.dashboard_outlined, Icons.dashboard, "Dashboard"),
                _navItem(1, Icons.restaurant_menu_outlined, Icons.restaurant_menu, "Menu"),
                _navItem(2, Icons.list_alt_outlined, Icons.list_alt, "Orders"),
                _navItem(3, Icons.payment_outlined, Icons.payment, "Payments"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF9B1C1C).withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFF9B1C1C) : Colors.grey[500],
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF9B1C1C),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
