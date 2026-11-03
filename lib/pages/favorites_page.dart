import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/page_decor.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);
const Color _red = Color(0xFFE5393F);

class _Workshop {
  final String name;
  final double rating;
  final int reviews;
  final String address;
  final String distance;
  final String hours;
  final String priceFrom;
  final bool isOpen;
  final int highlight; // xizmat ikonkalaridan qaysi biri ajratib ko'rsatiladi

  const _Workshop({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.address,
    required this.distance,
    required this.hours,
    required this.priceFrom,
    required this.isOpen,
    required this.highlight,
  });

  // Nomning dastlabki ikki so'zidan bosh harflar
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    final letters = words.take(2).map((w) => w[0].toUpperCase()).join();
    return letters;
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // TODO: keyinchalik API'dan keladi (GET /api/bookings/workshops)
  final List<_Workshop> _items = [
    const _Workshop(
      name: 'CarWash Service Center',
      rating: 4.8,
      reviews: 214,
      address: 'Amir Temur str, 108',
      distance: '1.2 km',
      hours: 'Mon-Sat, 09:00 - 20:00',
      priceFrom: 'from 90 000 UZS',
      isOpen: true,
      highlight: 2,
    ),
    const _Workshop(
      name: 'AutoFix Garage',
      rating: 4.6,
      reviews: 158,
      address: 'Mustaqillik str, 45',
      distance: '2.4 km',
      hours: 'Mon-Sat, 09:00 - 20:00',
      priceFrom: 'from 120 000 UZS',
      isOpen: true,
      highlight: 5,
    ),
    const _Workshop(
      name: 'Turbo Tire Service',
      rating: 4.7,
      reviews: 96,
      address: 'Navoi str, 17',
      distance: '3.1 km',
      hours: 'Mon-Sun, 08:00 - 21:00',
      priceFrom: 'from 60 000 UZS',
      isOpen: true,
      highlight: 1,
    ),
  ];

  void _soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what will be added later')),
    );
  }

  void _remove(int index) {
    final removed = _items[index];
    // TODO: serverda ham sevimlilardan o'chirish
    setState(() => _items.removeAt(index));

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${removed.name} removed from favorites'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _items.insert(index, removed)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: PageBackgroundPainter()),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: PageHeader(title: 'FAVORITE'),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Your saved workshops',
                    style: GoogleFonts.montserrat(fontSize: 12, color: _muted),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _items.isEmpty
                      ? Center(
                    child: Text(
                      'No saved workshops yet',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: _muted),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _items.length,
                    itemBuilder: (context, i) => _WorkshopCard(
                      workshop: _items[i],
                      onBook: () => _soon('Booking'),
                      onView: () => _soon('Workshop details'),
                      onUnfavorite: () => _remove(i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ustaxona kartasi
// ---------------------------------------------------------------------------
const List<IconData> _serviceIcons = [
  Icons.local_car_wash_outlined,
  Icons.tire_repair_outlined,
  Icons.oil_barrel_outlined,
  Icons.tune_rounded,
  Icons.album_outlined,
  Icons.build_outlined,
];

class _WorkshopCard extends StatelessWidget {
  final _Workshop workshop;
  final VoidCallback onBook;
  final VoidCallback onView;
  final VoidCallback onUnfavorite;

  const _WorkshopCard({
    required this.workshop,
    required this.onBook,
    required this.onView,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    final open = workshop.isOpen;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + nom + reyting + Open
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _teal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  workshop.initials,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshop.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: Color(0xFFFFB800)),
                        const SizedBox(width: 3),
                        Text(
                          workshop.rating.toString(),
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(${workshop.reviews} reviews)',
                          style: GoogleFonts.montserrat(
                              fontSize: 10, color: _muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: open
                      ? const Color(0xFFDDF5EC)
                      : const Color(0xFFFAD4D6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  open ? 'Open' : 'Closed',
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: open ? _teal : _red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ma'lumot qatorlari
          _InfoLine(
            icon: Icons.location_on_outlined,
            text: '${workshop.address} \u00B7 ${workshop.distance}',
          ),
          const SizedBox(height: 6),
          _InfoLine(icon: Icons.schedule_rounded, text: workshop.hours),
          const SizedBox(height: 6),
          _InfoLine(
              icon: Icons.local_offer_outlined, text: workshop.priceFrom),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.25)),
          const SizedBox(height: 12),

          // Xizmat ikonkalari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_serviceIcons.length, (i) {
              final selected = i == workshop.highlight;
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selected ? _teal : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _teal.withValues(alpha: 0.8)),
                ),
                child: Icon(
                  _serviceIcons[i],
                  size: 16,
                  color: selected ? Colors.white : _teal,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Tugmalar
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Text(
                      'Book service',
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: OutlinedButton(
                    onPressed: onView,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _ink,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Text(
                      'View workshop',
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onUnfavorite,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: _red.withValues(alpha: 0.6)),
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      size: 17, color: _red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: _teal),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(fontSize: 10.5, color: _ink),
          ),
        ),
      ],
    );
  }
}