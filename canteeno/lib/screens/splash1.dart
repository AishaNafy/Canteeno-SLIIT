import 'package:flutter/material.dart';
import 'dart:math';
import 'login_screen.dart';

/// ─────────────────────────────────────────────────
/// ONBOARDING SCREEN – 4 pages with page indicators
/// ─────────────────────────────────────────────────
class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.delivery_dining,
      title: "Fast Delivery",
      subtitle: "Order your favorite meals and get\nthem delivered to your classroom",
      badgeColor: const Color(0xFFE8C16A),
    ),
    OnboardingData(
      icon: Icons.local_offer,
      title: "Exclusive Offers",
      subtitle: "Get special discounts and vouchers\non your favorite campus meals",
      badgeColor: const Color(0xFFE8C16A),
    ),
    OnboardingData(
      icon: Icons.room_service,
      title: "Fresh & Hot Food",
      subtitle: "Enjoy freshly prepared meals from\nyour campus cafeterias",
      badgeColor: const Color(0xFFE8C16A),
    ),
    OnboardingData(
      icon: Icons.cake,
      title: "Wide Menu Selection",
      subtitle: "Browse a wide variety of meals,\nsnacks, and beverages",
      badgeColor: const Color(0xFFE8C16A),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7A1520),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 15),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _skip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page Indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentPage == index ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFFE8C16A)
                          : Colors.white30,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8C16A),
                    foregroundColor: const Color(0xFF7A1520),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge with scalloped edge
          _ScallopedBadge(
            icon: data.icon,
            badgeColor: data.badgeColor,
          ),

          const SizedBox(height: 50),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── DATA MODEL ───
class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color badgeColor;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeColor,
  });
}

/// ─── SCALLOPED BADGE WIDGET ───
/// Recreates the gold/maroon badge design from the uploaded images
class _ScallopedBadge extends StatelessWidget {
  final IconData icon;
  final Color badgeColor;

  const _ScallopedBadge({
    required this.icon,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: _ScallopedCirclePainter(color: badgeColor),
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF7A1520),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 70,
              color: const Color(0xFF7A1520),
            ),
          ),
        ),
      ),
    );
  }
}

/// ─── SCALLOPED CIRCLE PAINTER ───
/// Draws the zig-zag / scalloped circular border like the badge images
class _ScallopedCirclePainter extends CustomPainter {
  final Color color;

  _ScallopedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..color = color;

    // Draw scalloped circle
    final path = Path();
    const int scallops = 24;
    const double innerRadius = 0.82;

    for (int i = 0; i < scallops * 2; i++) {
      final angle = (i * pi) / scallops;
      final r = i.isEven ? radius : radius * innerRadius;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Draw inner dotted circle border
    final dotPaint = Paint()
      ..color = const Color(0xFF7A1520)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const int dots = 60;
    const double dotRadius = 1.5;
    final double circleRadius = radius * 0.72;

    for (int i = 0; i < dots; i++) {
      final angle = (i * 2 * pi) / dots;
      final x = center.dx + circleRadius * cos(angle);
      final y = center.dy + circleRadius * sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

