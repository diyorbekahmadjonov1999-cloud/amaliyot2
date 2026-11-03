import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/page_decor.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);
const Color _red = Color(0xFFE5393F);

class _Review {
  final int id;
  final String workshop;
  final String service;
  final String orderId;
  final String date;
  final double rating;
  final int reviewsCount;
  final String text;
  final List<String> photos; // asset yo'llari
  final String? reply;

  const _Review({
    required this.id,
    required this.workshop,
    required this.service,
    required this.orderId,
    required this.date,
    required this.rating,
    required this.reviewsCount,
    required this.text,
    this.photos = const [],
    this.reply,
  });
}

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  // TODO: keyinchalik API'dan keladi
  final List<_Review> _reviews = [
    const _Review(
      id: 1,
      workshop: 'CarWash Service Center',
      service: 'Full Wash',
      orderId: 'ORD-2481',
      date: '25 Aug 2026',
      rating: 4.8,
      reviewsCount: 214,
      text: 'Car came back spotless and they finished 20 minutes earlier than '
          'promised. The interior smelled fresh and they even cleaned the '
          'door sills.',
      // TODO: o'zingizdagi rasm yo'llari (topilmasa, vaqtincha belgi chiqadi)
      photos: [
        'assets/images/review1.png',
        'assets/images/review2.png',
      ],
      reply: 'Thank you Ali! Always a pleasure \u2014 see you at the next wash.',
    ),
    const _Review(
      id: 2,
      workshop: 'AutoFix Garage',
      service: 'Oil change',
      orderId: 'ORD-2430',
      date: '14 Aug 2026',
      rating: 4.6,
      reviewsCount: 158,
      text: 'Quick and clear communication. They explained every step and '
          'the price matched the estimate.',
      photos: ['assets/images/review3.png'],
      reply: 'Thanks for trusting us with your car!',
    ),
    const _Review(
      id: 3,
      workshop: 'Turbo Tire Service',
      service: 'Tire fitting',
      orderId: 'ORD-2377',
      date: '02 Aug 2026',
      rating: 4.7,
      reviewsCount: 96,
      text: 'Good service, but the waiting area was a bit crowded.',
    ),
  ];

  Future<void> _confirmDelete(_Review r) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete this review?',
          style: GoogleFonts.montserrat(
              fontSize: 15, fontWeight: FontWeight.w700, color: _ink),
        ),
        content: Text(
          'Your review for ${r.workshop} will be removed.',
          style: GoogleFonts.montserrat(fontSize: 12, color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600, color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, color: _red)),
          ),
        ],
      ),
    );

    if (yes == true && mounted) {
      // TODO: serverdan ham o'chirish
      setState(() => _reviews.removeWhere((e) => e.id == r.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted')),
      );
    }
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
                  child: PageHeader(title: 'MY REVIEW'),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Reviews',
                    style: GoogleFonts.montserrat(fontSize: 12, color: _muted),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _reviews.isEmpty
                      ? Center(
                    child: Text(
                      'You have not written any reviews yet',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: _muted),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _reviews.length,
                    itemBuilder: (context, i) {
                      final r = _reviews[i];
                      return _ReviewCard(
                        key: ValueKey<int>(r.id),
                        review: r,
                        onDelete: () => _confirmDelete(r),
                      );
                    },
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
// Sharh kartasi
// ---------------------------------------------------------------------------
class _ReviewCard extends StatefulWidget {
  final _Review review;
  final VoidCallback onDelete;

  const _ReviewCard({super.key, required this.review, required this.onDelete});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  // Qo'shni rasmlar chetidan ko'rinib turishi uchun
  final PageController _photos = PageController(viewportFraction: 0.88);

  @override
  void dispose() {
    _photos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.review;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
          Text(
            r.workshop,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${r.service} \u00B7 ${r.orderId} ${r.date}',
            style: GoogleFonts.montserrat(fontSize: 9.5, color: _muted),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: 14, color: Color(0xFFFFB800)),
              const SizedBox(width: 3),
              Text(
                r.rating.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '(${r.reviewsCount} reviews)',
                style: GoogleFonts.montserrat(fontSize: 10, color: _muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            r.text,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              height: 1.45,
              color: const Color(0xFF6E7B78),
            ),
          ),

          // Rasmlar
          if (r.photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: PageView.builder(
                controller: _photos,
                padEnds: false,
                itemCount: r.photos.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _teal, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.5),
                      child: Image.asset(
                        r.photos[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE3EFEC),
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_outlined,
                              size: 32, color: _teal),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Ustaxona javobi
          if (r.reply != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.workshop,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r.reply!,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.5,
                      height: 1.4,
                      color: const Color(0xFF6E7B78),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: OutlinedButton.icon(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 15),
              label: Text(
                'Delete review',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _red,
                backgroundColor: Colors.white,
                side: BorderSide(color: _red.withValues(alpha: 0.7)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}