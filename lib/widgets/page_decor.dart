import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);

// ---------------------------------------------------------------------------
// Header: sarlavha + qo'ng'iroq belgisi + UZ / ENG / RU
// ---------------------------------------------------------------------------
class PageHeader extends StatefulWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  int _lang = 1; // 0 = UZ, 1 = ENG, 2 = RU

  @override
  Widget build(BuildContext context) {
    const langs = ['UZ', 'ENG', 'RU'];
    return Row(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.brunoAceSc(
            fontSize: 20,
            color: _ink,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_none_rounded,
              size: 18, color: Colors.redAccent),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: List.generate(langs.length, (i) {
              final selected = i == _lang;
              return GestureDetector(
                onTap: () => setState(() => _lang = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: selected ? _teal : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    langs[i],
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : _muted,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Orqa fon: ikkita diagonal yashil band
// ---------------------------------------------------------------------------
class PageBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final band1 = Path()
      ..moveTo(0, h * 0.30)
      ..quadraticBezierTo(w * 0.45, h * 0.26, w, h * 0.34)
      ..lineTo(w, h * 0.46)
      ..quadraticBezierTo(w * 0.5, h * 0.40, 0, h * 0.44)
      ..close();

    final band2 = Path()
      ..moveTo(0, h * 0.62)
      ..quadraticBezierTo(w * 0.5, h * 0.58, w, h * 0.70)
      ..lineTo(w, h * 0.86)
      ..quadraticBezierTo(w * 0.5, h * 0.74, 0, h * 0.80)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _teal.withValues(alpha: 0.45),
          _teal.withValues(alpha: 0.20),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(band1, paint);
    canvas.drawPath(band2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}