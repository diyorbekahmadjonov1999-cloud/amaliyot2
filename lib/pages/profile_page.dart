import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/page_decor.dart';
import 'account_page.dart';
import 'favorites_page.dart';
import 'my_reviews_page.dart';
import 'orders_page.dart';
import 'support_page.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // TODO: keyinchalik bu ma'lumotlar API'dan keladi
  static const String _fullName = 'Ali Valiyev';
  static const String _phone = '+998 (99) 997 45 12';
  static const String _carName = 'Chevrolet ONIX';
  static const String _carNumber = '10A345KD';

  void _openAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Orqa fon: diagonal yashil bandlar
          Positioned.fill(
            child: CustomPaint(painter: PageBackgroundPainter()),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              // pastdagi navigatsiya ostida qolmasligi uchun
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(title: 'PROFILE'),
                  const SizedBox(height: 18),
                  _AccountCard(
                    fullName: _fullName,
                    phone: _phone,
                    carName: _carName,
                    carNumber: _carNumber,
                    onUpdate: () => _openAccount(context),
                  ),
                  const SizedBox(height: 22),
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: Icons.person_outline,
                        title: 'Account',
                        subtitle: 'Name, phone, car',
                        onTap: () => _openAccount(context),
                      ),
                      _MenuItemData(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment',
                        subtitle: 'Cards and payment history',
                        onTap: () {},
                      ),
                      _MenuItemData(
                        icon: Icons.receipt_long_outlined,
                        title: 'Orders',
                        subtitle: 'Booking and service history',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const OrdersPage()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: Icons.favorite_border,
                        title: 'Favorite Workshops',
                        subtitle: '8 saved places',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FavoritesPage()),
                        ),
                      ),
                      _MenuItemData(
                        icon: Icons.star_border_rounded,
                        title: 'My Reviews',
                        subtitle: '5 reviews written',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyReviewsPage()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: Icons.support_agent_outlined,
                        title: 'Support',
                        subtitle: 'Help center',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SupportPage()),
                        ),
                      ),
                      _MenuItemData(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'Language, notifications, theme',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Account information kartasi
// ---------------------------------------------------------------------------
class _AccountCard extends StatelessWidget {
  final String fullName;
  final String phone;
  final String carName;
  final String carNumber;
  final VoidCallback onUpdate;

  const _AccountCard({
    required this.fullName,
    required this.phone,
    required this.carName,
    required this.carNumber,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 188,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF14B596), Color(0xFF009577)],
        ),
        boxShadow: [
          BoxShadow(
            color: _teal.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Mashina rasmi (o'ng tomonda)
            Positioned(
              right: -30,
              top: 28,
              width: 190,
              child: Image.asset(
                'assets/images/onix.png', // TODO: o'zingizdagi rasm yo'li
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.directions_car_filled_rounded,
                  size: 90,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account information',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: fullName,
                    subtitle: phone,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.directions_car_outlined,
                    title: carName,
                    subtitle: carNumber,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _teal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: Colors.white),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                fontSize: 9.5,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Menyu kartalari (Account / Payment / Orders ...)
// ---------------------------------------------------------------------------
class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItemData> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _MenuTile(data: items[i]),
            if (i != items.length - 1)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Colors.grey.withValues(alpha: 0.18),
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuItemData data;

  const _MenuTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: data.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(data.icon, size: 20, color: _teal),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.5,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: _ink),
          ],
        ),
      ),
    );
  }
}