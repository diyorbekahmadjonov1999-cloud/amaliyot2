import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/page_decor.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);
const Color _errorRed = Color(0xFFE53935);

class _Qa {
  final String q;
  final String a;
  const _Qa(this.q, this.a);
}

class _FaqGroup {
  final String title;
  final List<_Qa> items;
  const _FaqGroup(this.title, this.items);
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  int _tab = 0; // 0 = Help center, 1 = Contact Support
  int _openIndex = 0; // ochiq turgan FAQ guruhi (-1 = hammasi yopiq)

  // TODO: matnlar hozircha vaqtincha, keyin haqiqiylariga almashtiriladi
  static const List<_FaqGroup> _faq = [
    _FaqGroup('Frequently asked questions', [
      _Qa(
        'Do I need to pay before the service?',
        'No. You can pay in cash at the workshop or by card in the app after '
            'the work is confirmed. Some workshops ask for a 50% deposit for '
            'large jobs.',
      ),
      _Qa(
        'Can I change the workshop after booking?',
        'Yes. Cancel the current booking and create a new one with another '
            'workshop. Cancellation is free up to 2 hours before the visit.',
      ),
    ]),
    _FaqGroup('How to place an order', [
      _Qa(
        'How do I book a service?',
        'Open Search, choose a category and a workshop, pick a time and '
            'confirm your booking.',
      ),
    ]),
    _FaqGroup('Payments and refunds', [
      _Qa(
        'When will I get my refund?',
        'Refunds to a card usually arrive within 3-5 working days after the '
            'booking is cancelled.',
      ),
    ]),
    _FaqGroup('Cancelling or rescheduling an order', [
      _Qa(
        'How can I reschedule a booking?',
        'Open the upcoming appointment on the Home screen and press '
            '"Reschedule", then choose a new time.',
      ),
    ]),
    _FaqGroup('Workshop disputes', [
      _Qa(
        'What if I am not satisfied with the work?',
        'Send us a ticket in "Contact Support" with the order and photos. '
            'We will review it and contact the workshop.',
      ),
    ]),
    _FaqGroup('Account and car management', [
      _Qa(
        'How do I change my car details?',
        'Go to Profile > Account, update the fields and press Save.',
      ),
    ]),
  ];

  // Contact Support formasi
  static const List<String> _categories = [
    'Booking issue',
    'Payment problem',
    'Workshop complaint',
    'Account and car',
    'Other',
  ];

  // TODO: keyinchalik foydalanuvchining haqiqiy buyurtmalari (API) bo'ladi
  static const List<String> _orders = [
    'No related order',
    'Latest order',
  ];

  final _descCtrl = TextEditingController();
  String? _category;
  String? _order;
  String? _categoryError;
  String? _descError;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _categoryError =
      _category == null ? 'Please select an issue category.' : null;
      _descError = _descCtrl.text.trim().length < 10
          ? 'Please describe the problem (at least 10 characters).'
          : null;
    });
    if (_categoryError != null || _descError != null) return;

    // TODO: tiketni serverga yuborish
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ticket submitted')),
    );
    setState(() {
      _category = null;
      _order = null;
      _descCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: PageBackgroundPainter()),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: PageHeader(title: 'SUPPORT'),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _TabSwitcher(
                      index: _tab,
                      labels: const ['Help Center', 'Contact Support'],
                      onChanged: (i) => setState(() => _tab = i),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: KeyedSubtree(
                          key: ValueKey<int>(_tab),
                          child: _tab == 0 ? _buildHelp() : _buildContact(),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: _EmergencyCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Help Center ---------------------------------------------------------
  Widget _buildHelp() {
    return Column(
      children: List.generate(_faq.length, (i) {
        final group = _faq[i];
        final open = _openIndex == i;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: open ? const Color(0xFFF2F4F4) : Colors.white,
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
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _openIndex = open ? -1 : i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.title,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: open ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: _ink),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: open
                    ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.grey.withValues(alpha: 0.25),
                      ),
                      for (final qa in group.items) ...[
                        const SizedBox(height: 12),
                        Text(
                          qa.q,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          qa.a,
                          style: GoogleFonts.montserrat(
                            fontSize: 10.5,
                            height: 1.4,
                            color: _muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ---- Contact Support -----------------------------------------------------
  Widget _buildContact() {
    return Container(
      width: double.infinity,
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
          _label('Issue category'),
          _SupportDropdown(
            value: _category,
            items: _categories,
            errorText: _categoryError,
            onChanged: (v) => setState(() {
              _category = v;
              _categoryError = null;
            }),
          ),
          const SizedBox(height: 14),
          _label('Related order'),
          _SupportDropdown(
            value: _order,
            items: _orders,
            onChanged: (v) => setState(() => _order = v),
          ),
          const SizedBox(height: 14),
          _label('Describe the problem'),
          TextField(
            controller: _descCtrl,
            maxLines: 5,
            minLines: 5,
            cursorColor: _teal,
            style: GoogleFonts.montserrat(fontSize: 12, color: _ink),
            decoration: _decoration(
              hint: 'Tell us what happened',
              errorText: _descError,
            ),
            onChanged: (_) {
              if (_descError != null) setState(() => _descError = null);
            },
          ),
          const SizedBox(height: 14),
          _label('Attachments'),
          GestureDetector(
            onTap: () {
              // TODO: fayl tanlash (file_picker paketi kerak bo'ladi)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('File upload will be added later')),
              );
            },
            child: CustomPaint(
              painter: _DashedRRectPainter(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined,
                        size: 18, color: _ink),
                    const SizedBox(height: 2),
                    Text(
                      'upload file',
                      style: GoogleFonts.montserrat(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Submit ticket',
                style: GoogleFonts.montserrat(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Help Center / Contact Support almashtirgichi
// ---------------------------------------------------------------------------
class _TabSwitcher extends StatelessWidget {
  final int index;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  const _TabSwitcher({
    required this.index,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? _teal : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  labels[i],
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _muted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Emergency contact kartasi
// ---------------------------------------------------------------------------
class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE5393F);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: red.withValues(alpha: 0.6)),
            ),
            child: const Icon(Icons.phone_in_talk_outlined,
                size: 15, color: red),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency contact',
                style: GoogleFonts.montserrat(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: red,
                ),
              ),
              Text(
                '+998 (77) 004 28 99',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Yordamchi widgetlar
// ---------------------------------------------------------------------------
Widget _label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(
    text,
    style: GoogleFonts.montserrat(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: _ink,
    ),
  ),
);

InputDecoration _decoration({String? hint, String? errorText}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );

  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: GoogleFonts.montserrat(fontSize: 11, color: _muted),
    errorText: errorText,
    errorMaxLines: 2,
    errorStyle: GoogleFonts.montserrat(fontSize: 10, color: _errorRed),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    enabledBorder: border(Colors.grey.withValues(alpha: 0.45)),
    focusedBorder: border(_teal),
    errorBorder: border(_errorRed),
    focusedErrorBorder: border(_errorRed),
  );
}

class _SupportDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const _SupportDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: _decoration(errorText: errorText).copyWith(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 20, color: _ink),
          style: GoogleFonts.montserrat(fontSize: 12, color: _ink),
          items: items
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(10),
      ));
    final paint = Paint()
      ..color = _muted.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}