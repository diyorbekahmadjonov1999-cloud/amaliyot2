import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kTeal = Color(0xFF009577);

class ServiceCategory {
  final String title;
  final IconData icon; // Keyinchalik Figma'dan eksport qilingan SVG bilan almashtiriladi
  final int places;

  const ServiceCategory({
    required this.title,
    required this.icon,
    this.places = 12,
  });
}

class CategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: selected
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3DB8A0), Color(0xFF009577)],
          )
              : null,
          color: selected ? null : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HexagonIcon(icon: category.icon, selected: selected),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: selected ? Colors.white : kTeal,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${category.places} places',
              style: GoogleFonts.montserrat(
                fontSize: 8,
                color: selected ? Colors.white70 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexagonIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final double size;

  const HexagonIcon({
    super.key,
    required this.icon,
    required this.selected,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HexagonPainter(
          fill: Colors.white,
          stroke: selected ? Colors.white : kTeal,
        ),
        child: Center(
          child: Icon(icon, size: size * 0.48, color: kTeal),
        ),
      ),
    );
  }
}

class _HexagonPainter extends CustomPainter {
  final Color fill;
  final Color stroke;

  _HexagonPainter({required this.fill, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = -math.pi / 2 + i * math.pi / 3;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter old) =>
      old.fill != fill || old.stroke != stroke;
}