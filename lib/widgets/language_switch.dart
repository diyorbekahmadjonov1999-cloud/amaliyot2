import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _teal = Color(0xFF009577);

/// Tanlangan til (0 = UZ, 1 = ENG, 2 = RU).
/// Barcha sahifalar shu qiymatni ulashadi, shuning uchun bir joyda
/// o'zgartirsangiz, boshqa sahifalarda ham o'zgaradi.
final ValueNotifier<int> appLanguageIndex = ValueNotifier<int>(1);

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  static const List<String> _langs = ['UZ', 'ENG', 'RU'];
  static const double _itemWidth = 36;
  static const double _itemHeight = 26;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appLanguageIndex,
      builder: (context, index, _) {
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SizedBox(
            width: _itemWidth * _langs.length,
            height: _itemHeight,
            child: Stack(
              children: [
                // Siljib yuradigan yashil belgi
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  left: index * _itemWidth,
                  top: 0,
                  width: _itemWidth,
                  height: _itemHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _teal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // Til yozuvlari
                Row(
                  children: List.generate(_langs.length, (i) {
                    final selected = i == index;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => appLanguageIndex.value = i,
                      child: SizedBox(
                        width: _itemWidth,
                        height: _itemHeight,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : _teal,
                            ),
                            child: Text(_langs[i]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}