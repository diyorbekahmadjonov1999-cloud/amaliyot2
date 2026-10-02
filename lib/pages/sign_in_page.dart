import 'package:amaliyot2/pages/verify_sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backgrounds/create_account_background.dart';
import '../services/auth_service.dart';
import '../widgets/create_account_buttons.dart';
import '../widgets/custom_input.dart';
import '../widgets/sign_in_bottom.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phoneController = TextEditingController();

  String? _phoneError;
  bool _isSubmitting = false;

  static const int _requiredPhoneDigits = 9; // +998 dan keyingi 9 ta raqam

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleClear() {
    setState(() {
      _phoneController.clear();
      _phoneError = null;
    });
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

  Future<void> _handleContinue() async {
    final phoneError = _validatePhone(_phoneController.text);

    setState(() {
      _phoneError = phoneError;
    });

    if (_phoneError != null || _isSubmitting) return;

    final fullPhone =
        '+998${_phoneController.text.replaceAll(RegExp(r'\D'), '')}';

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await AuthService.login(fullPhone);

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifySignInPage(phoneNumber: fullPhone),
          ),
        );
      } else {
        setState(() {
          _phoneError =
          'No account found with this phone number. Please create an account first.';
        });
      }
    } catch (e) {
      setState(() {
        _phoneError = 'Internetni tekshiring, so\'rov yuborilmadi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
              child: SignInBottom(),
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

                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
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
                    'Welcome back',
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

                  SizedBox(height: 24),

                  CreateAccountButtons(
                    onClear: _handleClear,
                    onContinue: _isSubmitting ? null : _handleContinue,
                  ),

                  if (_isSubmitting) ...[
                    SizedBox(height: 16),
                    CircularProgressIndicator(color: Color(0xFF009577)),
                  ],

                ],
              ),
            ))
          ],
        ),


      ),
    );
  }
}