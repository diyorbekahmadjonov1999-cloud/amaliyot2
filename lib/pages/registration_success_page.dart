import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backgrounds/create_account_background.dart';
import 'main_page.dart';

class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  static const Color _teal = Color(0xFF009577);

  void _handleContinue(BuildContext context) {
    // Home sahifasiga o'tamiz va oldingi sahifalarni yopamiz
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainPage()),
          (route) => false,
    );
  }

  Widget _buildCheckCircles() {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _teal.withValues(alpha: 0.25)),
            ),
          ),
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _teal.withValues(alpha: 0.10),
            ),
          ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _teal.withValues(alpha: 0.20),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _teal,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CreateAccountBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  _buildCheckCircles(),
                  const SizedBox(height: 24),
                  Text(
                    'Registration',
                    style: GoogleFonts.brunoAceSc(
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Successful',
                    style: GoogleFonts.brunoAceSc(
                      fontSize: 28,
                      color: _teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome! Your account has been created successfully.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () => _handleContinue(context),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _teal,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF0EBE5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFF0EBE5),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}