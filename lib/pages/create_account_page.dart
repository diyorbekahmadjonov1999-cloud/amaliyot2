import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backgrounds/create_account_background.dart';
import '../widgets/create_account_bottom.dart';
import '../widgets/create_account_buttons.dart';
import '../widgets/custom_input.dart';
import 'car_details_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _fullNameError;
  String? _phoneError;

  static const int _minFullNameLength = 7;
  static const int _requiredPhoneDigits = 9; // +998 dan keyingi 9 ta raqam

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleClear() {
    setState(() {
      _fullNameController.clear();
      _phoneController.clear();
      _fullNameError = null;
      _phoneError = null;
    });
  }

  String? _validateFullName(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Please enter your full name.';
    }
    if (trimmed.length < _minFullNameLength) {
      return 'Full name must be at least $_minFullNameLength characters.';
    }
    // Kamida ism va familiya (ikkita so'z) kiritilganini tekshiradi
    final words = trimmed.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.length < 2) {
      return 'Please enter your full name (name and surname).';
    }
    return null;
  }

  String? _validatePhone(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.isEmpty) {
      return 'Please enter your phone number.';
    }
    if (digitsOnly.length < _requiredPhoneDigits) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  void _handleContinue() {
    final fullNameError = _validateFullName(_fullNameController.text);
    final phoneError = _validatePhone(_phoneController.text);

    setState(() {
      _fullNameError = fullNameError;
      _phoneError = phoneError;
    });

    if (_fullNameError == null && _phoneError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CarDetailsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [

            // 1-QAVAT:
            Positioned.fill(
              child: CreateAccountBackground(),
            ),

            Positioned(
              left: 0,
              bottom: 0,
              child: CreateAccountBottom(),
            ),


            // 2-QAVAT:

            SafeArea(child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(

                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Color(0xFF00897B),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: [
                              Text("UZ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFF00897B),
                                child: Text("ENG", style: TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                              SizedBox(width: 8),
                              Text("RU", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80),

                  Text(
                    'Create Account',
                    style: GoogleFonts.brunoAce(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),

                  Text(
                    'House engine',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Color(0xFF909090),
                    ),
                  ),

                  SizedBox(height: 50),

                  Column(
                    children: [
                      CustomInput(
                        label: 'Full name',
                        hintText: 'Alisherov Alisher',
                        controller: _fullNameController,
                        errorText: _fullNameError,
                        onChanged: (_) {
                          if (_fullNameError != null) {
                            setState(() => _fullNameError = null);
                          }
                        },
                      ),

                      SizedBox(height: 24),

                      CustomInput(
                        label: 'Phone number',
                        hintText: '(99) 928-48-14',
                        prefixText: '+998 ',
                        controller: _phoneController,
                        errorText: _phoneError,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  CreateAccountButtons(
                    onClear: _handleClear,
                    onContinue: _handleContinue,
                  ),

                ],
              ),
            ))
          ],
        ),


      ),
    );
  }
}