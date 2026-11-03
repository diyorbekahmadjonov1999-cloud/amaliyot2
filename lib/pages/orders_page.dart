import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/page_decor.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);
const Color _red = Color(0xFFE5393F);

enum _Status { confirmed, inProgress, ready, completed, cancelled }

enum _ChipKind { red, grey, green, orange }

class _Order {
  final String id;
  final String date;
  final String workshop;
  final String service;
  final String when;
  final String payment; // "Credit card" / "Cash"
  final String paymentChip; // "Paid 50%" / "Not paid" / "Paid"
  final _ChipKind paymentChipKind;
  final String amount;
  final double? progress; // null bo'lsa, progress ko'rsatilmaydi
  _Status status;

  _Order({
    required this.id,
    required this.date,
    required this.workshop,
    required this.service,
    required this.when,
    required this.payment,
    required this.paymentChip,
    required this.paymentChipKind,
    required this.amount,
    required this.status,
    this.progress,
  });
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _tab = 0; // 0 = Active, 1 = Completed, 2 = Cancelled

  // TODO: keyinchalik API'dan keladi (GET /api/bookings)
  final List<_Order> _orders = [
    _Order(
      id: 'ORD-2481',
      date: '25 Aug 2026',
      workshop: 'CarWash Service Center',
      service: 'Full car wash',
      when: 'Tomorrow, 16:00',
      payment: 'Credit card',
      paymentChip: 'Paid 50%',
      paymentChipKind: _ChipKind.red,
      amount: '500 000 uzs',
      status: _Status.confirmed,
    ),
    _Order(
      id: 'ORD-2479',
      date: '24 Aug 2026',
      workshop: 'CarWash Service Center',
      service: 'Full car wash',
      when: 'Tomorrow, 16:00',
      payment: 'Cash',
      paymentChip: 'Not paid',
      paymentChipKind: _ChipKind.grey,
      amount: '500 000 uzs',
      status: _Status.inProgress,
      progress: 0.65,
    ),
    _Order(
      id: 'ORD-2475',
      date: '23 Aug 2026',
      workshop: 'CarWash Service Center',
      service: 'Full car wash',
      when: 'Tomorrow, 16:00',
      payment: 'Cash',
      paymentChip: 'Paid',
      paymentChipKind: _ChipKind.green,
      amount: '500 000 uzs',
      status: _Status.ready,
      progress: 1.0,
    ),
    _Order(
      id: 'ORD-2468',
      date: '12 Aug 2026',
      workshop: 'CarWash Service Center',
      service: 'Full car wash',
      when: 'Tomorrow, 16:00',
      payment: 'Credit card',
      paymentChip: 'Paid',
      paymentChipKind: _ChipKind.green,
      amount: '500 000 uzs',
      status: _Status.completed,
      progress: 1.0,
    ),
    _Order(
      id: 'ORD-2460',
      date: '05 Aug 2026',
      workshop: 'CarWash Service Center',
      service: 'Full car wash',
      when: 'Tomorrow, 16:00',
      payment: 'Cash',
      paymentChip: 'Not paid',
      paymentChipKind: _ChipKind.grey,
      amount: '500 000 uzs',
      status: _Status.cancelled,
    ),
  ];

  bool _inCurrentTab(_Order o) {
    switch (_tab) {
      case 0:
        return o.status == _Status.confirmed ||
            o.status == _Status.inProgress ||
            o.status == _Status.ready;
      case 1:
        return o.status == _Status.completed;
      default:
        return o.status == _Status.cancelled;
    }
  }

  void _soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what will be added later')),
    );
  }

  Future<void> _confirmCancel(_Order o) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel this order?',
          style: GoogleFonts.montserrat(
              fontSize: 15, fontWeight: FontWeight.w700, color: _ink),
        ),
        content: Text(
          '${o.id} will be moved to the Cancelled list.',
          style: GoogleFonts.montserrat(fontSize: 12, color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('No',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600, color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Yes, cancel',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, color: _red)),
          ),
        ],
      ),
    );
    if (yes == true) {
      // TODO: serverga bekor qilish so'rovini yuborish
      setState(() => o.status = _Status.cancelled);
    }
  }

  void _onAction(_Order o, String label) {
    if (label == 'Cancel order') {
      _confirmCancel(o);
    } else {
      // TODO: View details, Reschedule, Contact workshop, Repeat order, Leave a review
      _soon(label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _orders.where(_inCurrentTab).toList();

    return Scaffold(
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
                  child: PageHeader(title: 'ORDERS'),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _TabSwitcher(
                    index: _tab,
                    labels: const ['Active', 'Completed', 'Cancelled'],
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: visible.isEmpty
                        ? Center(
                      key: ValueKey<String>('empty$_tab'),
                      child: Text(
                        'No orders here yet',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: _muted),
                      ),
                    )
                        : ListView.builder(
                      key: ValueKey<int>(_tab),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: visible.length,
                      itemBuilder: (context, i) => _OrderCard(
                        order: visible[i],
                        onAction: (label) => _onAction(visible[i], label),
                      ),
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
// Buyurtma kartasi
// ---------------------------------------------------------------------------
enum _BtnStyle { filled, outlined, danger }

class _Btn {
  final String label;
  final _BtnStyle style;
  const _Btn(this.label, this.style);
}

class _OrderCard extends StatelessWidget {
  final _Order order;
  final void Function(String label) onAction;

  const _OrderCard({required this.order, required this.onAction});

  List<_Btn> get _actions {
    switch (order.status) {
      case _Status.confirmed:
        return const [
          _Btn('View details', _BtnStyle.filled),
          _Btn('Reschedule', _BtnStyle.outlined),
          _Btn('Contact workshop', _BtnStyle.outlined),
          _Btn('Cancel order', _BtnStyle.danger),
        ];
      case _Status.inProgress:
      case _Status.ready:
        return const [
          _Btn('View details', _BtnStyle.filled),
          _Btn('Contact workshop', _BtnStyle.outlined),
        ];
      case _Status.completed:
        return const [
          _Btn('View details', _BtnStyle.filled),
          _Btn('Repeat order', _BtnStyle.outlined),
          _Btn('Leave a review', _BtnStyle.outlined),
        ];
      case _Status.cancelled:
        return const [
          _Btn('View details', _BtnStyle.filled),
          _Btn('Repeat order', _BtnStyle.outlined),
        ];
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case _Status.confirmed:
        return 'Confirmed';
      case _Status.inProgress:
        return 'In progress';
      case _Status.ready:
        return 'Ready for pickup';
      case _Status.completed:
        return 'Completed';
      case _Status.cancelled:
        return 'Cancelled';
    }
  }

  Color get _statusBg {
    switch (order.status) {
      case _Status.confirmed:
        return const Color(0xFFE9ECEB);
      case _Status.inProgress:
        return const Color(0xFFFFE9D6);
      case _Status.ready:
      case _Status.completed:
        return const Color(0xFFDDF5EC);
      case _Status.cancelled:
        return const Color(0xFFFAD4D6);
    }
  }

  Color get _statusFg {
    switch (order.status) {
      case _Status.confirmed:
        return const Color(0xFF7A8A87);
      case _Status.inProgress:
        return const Color(0xFFE58A2B);
      case _Status.ready:
      case _Status.completed:
        return _teal;
      case _Status.cancelled:
        return _red;
    }
  }

  String get _progressLabel =>
      order.status == _Status.inProgress ? 'In progress' : 'Completed';

  @override
  Widget build(BuildContext context) {
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
          // ID + sana + status
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.id}  ${order.date}',
                  style: GoogleFonts.montserrat(fontSize: 9.5, color: _muted),
                ),
              ),
              _Chip(text: _statusLabel, bg: _statusBg, fg: _statusFg),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            order.workshop,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          const SizedBox(height: 8),
          _InfoLine(icon: Icons.local_car_wash_outlined, text: order.service),
          const SizedBox(height: 6),
          _InfoLine(icon: Icons.calendar_month_outlined, text: order.when),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.25)),

          // Ish progressi
          if (order.progress != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Work',
                    style:
                    GoogleFonts.montserrat(fontSize: 9, color: _muted)),
                const Spacer(),
                Text(_progressLabel,
                    style:
                    GoogleFonts.montserrat(fontSize: 9, color: _muted)),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: order.progress,
                minHeight: 5,
                backgroundColor: const Color(0xFFE3E7E6),
                valueColor: const AlwaysStoppedAnimation<Color>(_teal),
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.25)),
          ],

          // To'lov
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                order.payment,
                style: GoogleFonts.montserrat(fontSize: 10.5, color: _muted),
              ),
              const SizedBox(width: 8),
              _paymentChip(),
              const Spacer(),
              Text(
                order.amount,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tugmalar
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _actions
                    .map(
                      (a) => SizedBox(
                    width: w,
                    height: 32,
                    child: _PillButton(
                      label: a.label,
                      style: a.style,
                      onTap: () => onAction(a.label),
                    ),
                  ),
                )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _paymentChip() {
    switch (order.paymentChipKind) {
      case _ChipKind.red:
        return _Chip(
            text: order.paymentChip,
            bg: const Color(0xFFFAD4D6),
            fg: _red);
      case _ChipKind.green:
        return _Chip(
            text: order.paymentChip,
            bg: const Color(0xFFDDF5EC),
            fg: _teal);
      case _ChipKind.orange:
        return _Chip(
            text: order.paymentChip,
            bg: const Color(0xFFFFE9D6),
            fg: const Color(0xFFE58A2B));
      case _ChipKind.grey:
        return _Chip(
            text: order.paymentChip,
            bg: const Color(0xFFE9ECEB),
            fg: const Color(0xFF7A8A87));
    }
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
        Text(
          text,
          style: GoogleFonts.montserrat(fontSize: 11, color: _ink),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Chip({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final _BtnStyle style;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(fontSize: 10.5, fontWeight: FontWeight.w600),
    );

    if (style == _BtnStyle.filled) {
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _teal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: text,
      );
    }

    final color = style == _BtnStyle.danger ? _red : _ink;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        side: BorderSide(
          color: style == _BtnStyle.danger
              ? _red.withValues(alpha: 0.7)
              : Colors.grey.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: text,
    );
  }
}

// ---------------------------------------------------------------------------
// Active / Completed / Cancelled almashtirgichi
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