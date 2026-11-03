import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/category_card.dart';
import '../widgets/header_actions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  static const List<ServiceCategory> _allCategories = [
    ServiceCategory(title: 'Work shops', icon: Icons.build_outlined),
    ServiceCategory(title: 'Diagnostics', icon: Icons.monitor_heart_outlined),
    ServiceCategory(title: 'Oil & Fluids', icon: Icons.oil_barrel_outlined),
    ServiceCategory(title: 'Tire Service', icon: Icons.tire_repair),
    ServiceCategory(title: 'Car wash', icon: Icons.local_car_wash_outlined),
    ServiceCategory(title: 'Auto Electrician', icon: Icons.bolt),
    ServiceCategory(title: 'Engine Repair', icon: Icons.settings_outlined),
    ServiceCategory(
        title: 'Transmission Repair', icon: Icons.settings_input_component),
    ServiceCategory(title: 'Suspension & Steering', icon: Icons.swap_vert),
    ServiceCategory(title: 'Brake Service', icon: Icons.speed),
    ServiceCategory(title: 'Body Repair', icon: Icons.directions_car_outlined),
    ServiceCategory(title: 'Paint', icon: Icons.format_paint_outlined),
    ServiceCategory(title: 'A/C & Heating', icon: Icons.ac_unit),
    ServiceCategory(
        title: 'Battery Service', icon: Icons.battery_charging_full),
    ServiceCategory(title: 'Tuning & Modification', icon: Icons.tune),
    ServiceCategory(title: 'Auto Glass', icon: Icons.window_outlined),
    ServiceCategory(
        title: 'Accessories & Installation', icon: Icons.videocam_outlined),
    ServiceCategory(title: 'EV Service & Charging', icon: Icons.ev_station),
  ];

  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _appearController;
  String _query = '';
  int _selectedIndex = 0; // Figma'da birinchi karta tanlangan holatda

  List<ServiceCategory> get _filtered {
    if (_query.trim().isEmpty) return _allCategories;
    final q = _query.trim().toLowerCase();
    return _allCategories
        .where((c) => c.title.toLowerCase().contains(q))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Sahifa ochilganda kartalar birin-ketin paydo bo'ladi
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _appearController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Orqa fon (diagonal teal chiziqlar)
          Positioned.fill(
            child: CustomPaint(painter: _SearchBackgroundPainter()),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildSearchBar(),
                  const SizedBox(height: 18),
                  Text(
                    'Categories',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: categories.isEmpty
                        ? Center(
                      child: Text(
                        'Nothing found',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                        : GridView.builder(
                      // Pastki navigatsiya yopib qo'ymasligi uchun joy
                      padding: const EdgeInsets.only(
                          bottom: 110, left: 2, right: 2, top: 2),
                      itemCount: categories.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.88,
                      ),
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        final originalIndex =
                        _allCategories.indexOf(item);
                        final start = (index * 0.035).clamp(0.0, 0.55);
                        final anim = CurvedAnimation(
                          parent: _appearController,
                          curve: Interval(start, start + 0.45,
                              curve: Curves.easeOutBack),
                        );
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _appearController,
                            curve: Interval(start, start + 0.3),
                          ),
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.6, end: 1.0)
                                .animate(anim),
                            child: CategoryCard(
                              category: item,
                              selected: _selectedIndex == originalIndex,
                              onTap: () => setState(
                                      () => _selectedIndex = originalIndex),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Search',
          style: GoogleFonts.brunoAceSc(
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        const HeaderActions(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        style: GoogleFonts.montserrat(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Car wash, workshop',
          hintStyle: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
          prefixIcon: const Icon(Icons.search, color: kTeal, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }
}

class _SearchBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final band1 = Path()
      ..moveTo(0, h * 0.14)
      ..quadraticBezierTo(w * 0.55, h * 0.12, w, h * 0.30)
      ..lineTo(w, h * 0.46)
      ..quadraticBezierTo(w * 0.45, h * 0.26, 0, h * 0.34)
      ..close();

    final band2 = Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.5, h * 0.50, w, h * 0.62)
      ..lineTo(w, h * 0.72)
      ..quadraticBezierTo(w * 0.5, h * 0.60, 0, h * 0.68)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          kTeal.withOpacity(0.55),
          kTeal.withOpacity(0.25),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(band1, paint);
    canvas.drawPath(band2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}