import 'package:flutter/material.dart';

import 'language_switch.dart';

/// Sahifa sarlavhasining o'ng tomoni: bildirishnoma tugmasi + til almashtirgich.
class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  static const Color _teal = Color(0xFF009577);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_none, size: 18, color: _teal),
        ),
        const SizedBox(width: 10),
        const LanguageSwitch(),
      ],
    );
  }
}