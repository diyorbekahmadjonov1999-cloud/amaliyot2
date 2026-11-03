import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primary = Color(0xFF009577);

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.search, 'label': 'Search'},
    {'icon': Icons.directions_car_outlined, 'label': 'My garage'},
    {'icon': Icons.auto_awesome, 'label': 'Assistant'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = constraints.maxWidth / _items.length;
          const circleSize = 54.0;
          final circleLeft =
              slotWidth * currentIndex + (slotWidth - circleSize) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Yashil panel
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: List.generate(_items.length, (i) {
                      final selected = i == currentIndex;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(i),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Tanlangan icon dumaloq ichida ko'rinadi,
                                // shuning uchun bu yerda yashiramiz
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 200),
                                  opacity: selected ? 0 : 1,
                                  child: Icon(
                                    _items[i]['icon'] as IconData,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  _items[i]['label'] as String,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 8,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Siljib yuradigan dumaloq
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: circleLeft,
                bottom: 22,
                child: IgnorePointer(
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        _items[currentIndex]['icon'] as IconData,
                        key: ValueKey(currentIndex),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}