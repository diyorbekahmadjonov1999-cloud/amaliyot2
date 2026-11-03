import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/custom_bottom_nav.dart';
import 'assistant_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Pastki navigatsiyaning taxminiy balandligi (kerak bo'lsa o'zgartiring)
  static const double _navHeight = 78;

  // Har bir tab uchun sahifa. Hali tayyor bo'lmaganlari uchun vaqtincha placeholder.
  Widget _buildPage(int index, double bottomPadding) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const SearchPage();
      case 2:
        return const _PlaceholderPage(title: 'My garage');
      case 3:
        return AssistantPage(bottomPadding: bottomPadding);
      case 4:
      default:
        return const ProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Klaviatura ochiq bo'lsa, navigatsiya yashiriladi (yozish paneli ustida qolmasligi uchun)
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Sahifalar: kichikdan kattalashib ochiladi (scale + fade)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.92, end: 1.0)
                        .animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _buildPage(
                  _currentIndex,
                  keyboardOpen ? 0 : _navHeight,
                ),
              ),
            ),
          ),
          // Pastki navigatsiya
          if (!keyboardOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNav(
                currentIndex: _currentIndex,
                onTap: (i) {
                  if (i != _currentIndex) setState(() => _currentIndex = i);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF009577),
        ),
      ),
    );
  }
}