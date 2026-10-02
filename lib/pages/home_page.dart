import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primary = Color(0xFF009577);

  String _selectedLang = 'ENG';
  int _currentIndex = 0;

  // Hozircha statik ma'lumot (keyin API'dan olinadi)
  final String _userName = 'Ali';

  final List<Map<String, String>> _upcoming = [
    {'title': 'Auto Diagnostics', 'place': 'Car Tech Center', 'date': '29 Jul'},
    {'title': 'Engine Repair', 'place': 'Lukoil Oil', 'date': '30 Jul'},
    {'title': 'Brake Service', 'place': 'Mannol Oil', 'date': '31 Jul'},
  ];

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              Text(
                '$_greeting, $_userName',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildAppointmentCard(),
              const SizedBox(height: 16),
              Center(child: _buildRescheduleButton()),
              const SizedBox(height: 24),
              _buildUpcomingList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Home',
          style: GoogleFonts.brunoAceSc(fontSize: 24, color: Colors.black),
        ),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.notifications_none,
                  size: 18, color: primary),
            ),
            const SizedBox(width: 10),
            _buildLangSwitch(),
          ],
        ),
      ],
    );
  }

  Widget _buildLangSwitch() {
    final langs = ['UZ', 'ENG', 'RU'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: langs.map((l) {
          final selected = l == _selectedLang;
          return GestureDetector(
            onTap: () => setState(() => _selectedLang = l),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l,
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : primary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------- APPOINTMENT CARD ----------------
  Widget _buildAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A58E), Color(0xFF008F7A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF00695A),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'UPCOMING APPOINTMENT',
              style: GoogleFonts.montserrat(
                fontSize: 7,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'CarWash Service Center',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(
              Icons.calendar_today_outlined, 'Tomorrow, 16:00', 'Date & Time'),
          const SizedBox(height: 10),
          _infoRow(Icons.location_on_outlined, 'Amir Temur str, 108, Tas',
              'Location'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                fontSize: 7,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRescheduleButton() {
    return SizedBox(
      width: 184,
      height: 38,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A58E),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Reschedule',
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------- UPCOMING LIST ----------------
  Widget _buildUpcomingList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_upcoming.length, (i) {
          final item = _upcoming[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            item['place']!,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item['date']!,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (i != _upcoming.length - 1)
                Divider(height: 1, color: Colors.grey.shade300),
            ],
          );
        }),
      ),
    );
  }
}