import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backgrounds/create_account_background.dart';
import '../services/auth_service.dart';
import '../widgets/custom_input.dart';

class VerifySignInPage extends StatefulWidget {
  final String phoneNumber;

  const VerifySignInPage({super.key, required this.phoneNumber});

  @override
  State<VerifySignInPage> createState() => _VerifySignInPageState();
}

class _VerifySignInPageState extends State<VerifySignInPage> {
  final TextEditingController _codeController = TextEditingController();

  String? _codeError;
  bool _isSubmitting = false;

  static const int _resendSeconds = 47;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _resendSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Please enter the code.';
    }
    return null;
  }

  Future<void> _handleResend() async {
    if (_secondsLeft != 0) return;

    try {
      await AuthService.login(widget.phoneNumber);
      _startTimer();
    } catch (e) {
      setState(() {
        _codeError = 'Internetni tekshiring, so\'rov yuborilmadi.';
      });
    }
  }

  Future<void> _handleSubmit() async {
    final codeError = _validateCode(_codeController.text);

    setState(() {
      _codeError = codeError;
    });

    if (_codeError != null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await AuthService.verifyLogin(
        widget.phoneNumber,
        _codeController.text.trim(),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        // TODO: Login muvaffaqiyatli tasdiqlandi — Home/Dashboard sahifasi
        // tayyor bo'lgach, shu yerga Navigator.pushReplacement qo'shiladi.
      } else {
        setState(() {
          _codeError = 'Kod noto\'g\'ri. Qaytadan urinib ko\'ring.';
        });
      }
    } catch (e) {
      setState(() {
        _codeError = 'Internetni tekshiring, so\'rov yuborilmadi.';
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

            Positioned.fill(
              child: CreateAccountBackground(),
            ),

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

                  SizedBox(height: 60),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFE6F4F1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.message_outlined,
                      color: Color(0xFF009577),
                      size: 28,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'SMS verification',
                    style: GoogleFonts.brunoAce(
                      fontSize: 26,
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

                  SizedBox(height: 12),

                  Text(
                    'Enter the code from the SMS application',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF909090),
                    ),
                  ),

                  SizedBox(height: 40),

                  CustomInput(
                    label: 'Enter your code',
                    hintText: '12345',
                    controller: _codeController,
                    errorText: _codeError,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      if (_codeError != null) {
                        setState(() => _codeError = null);
                      }
                    },
                  ),

                  SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _handleResend,
                      child: Text(
                        _secondsLeft == 0
                            ? 'Resend code'
                            : 'Resend code ${_secondsLeft}s',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _secondsLeft == 0
                              ? Color(0xFF009577)
                              : Color(0xFF909090),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  GestureDetector(
                    onTap: _isSubmitting ? null : _handleSubmit,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF009577),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFFF0EBE5),
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          letterSpacing: 0,
                          color: Color(0xFFF0EBE5),
                        ),
                      ),
                    ),
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