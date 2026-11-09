import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backgrounds/create_account_background.dart';
import '../services/auth_service.dart';
import '../widgets/create_account_bottom.dart';
import 'registration_success_page.dart';

class VerifyRegisterPage extends StatefulWidget {
  final String phoneNumber;

  /// Kodni qayta yuborish uchun: CarMileagePage dan `AuthService.register(...)`
  /// ni qayta chaqiradigan funksiya beriladi.
  final Future<void> Function() onResend;

  const VerifyRegisterPage({
    super.key,
    required this.phoneNumber,
    required this.onResend,
  });

  @override
  State<VerifyRegisterPage> createState() => _VerifyRegisterPageState();
}

class _VerifyRegisterPageState extends State<VerifyRegisterPage> {
  static const Color _teal = Color(0xFF009577);
  static const int _codeLength = 6; // backendchi tasdiqlasin
  static const int _timerSeconds = 47;

  final TextEditingController _codeController = TextEditingController();

  Timer? _timer;
  int _secondsLeft = _timerSeconds;

  String? _codeError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _timerSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
      }
      if (mounted) {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resendCode() async {
    if (_secondsLeft > 0) return;
    setState(() => _codeError = null);
    try {
      await widget.onResend();
      _startTimer();
    } catch (e) {
      if (!mounted) return;
      setState(() => _codeError = 'Could not resend the code. Try again.');
    }
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() => _codeError = 'Please enter the code.');
      return;
    }
    if (code.length < _codeLength) {
      setState(() => _codeError = 'Enter the full $_codeLength-digit code.');
      return;
    }

    setState(() {
      _codeError = null;
      _isLoading = true;
    });

    try {
      // TEMP (faqat debug rejimida): backend SMS yubormaguncha oqimni
      // sinash uchun 000000 kodi o'tkazib yuboradi. Backend tayyor bo'lgach
      // shu if blokini o'chiring.
      if (kDebugMode && code == '000000') {
        _goToSuccess();
        return;
      }

      final response =
      await AuthService.verifyRegister(widget.phoneNumber, code);
      if (!mounted) return;

      if (response.statusCode != 200) {
        setState(
              () => _codeError = 'Invalid or expired code. Please try again.',
        );
        return;
      }

      _goToSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() => _codeError = 'Invalid or expired code. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToSuccess() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationSuccessPage()),
          (route) => false,
    );
  }

  Widget _buildResendRow() {
    if (_secondsLeft > 0) {
      return Row(
        children: [
          Text(
            'Resend code ',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            '${_secondsLeft}s',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: _resendCode,
      child: Text(
        'Resend code',
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _teal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _codeError != null;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CreateAccountBackground(),

          // Pastki bezak (kontent ostida turadi)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CreateAccountBottom(),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 110),

                  // Title
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'One-time code',
                          style: GoogleFonts.brunoAceSc(
                            fontSize: 28,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'House engine',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Info box
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: _teal,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Enter the one-time code to confirm your application',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Label
                  Text(
                    'Enter your code',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Code input
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: _codeLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) {
                      if (_codeError != null) {
                        setState(() => _codeError = null);
                      }
                    },
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '12000',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: hasError ? Colors.red : Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: hasError ? Colors.red : _teal,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // Error
                  if (hasError) ...[
                    const SizedBox(height: 6),
                    Text(
                      _codeError!,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.red,
                      ),
                    ),
                  ],

                   SizedBox(height: 10),

                  // Timer / Resend
                  _buildResendRow(),

                   SizedBox(height: 20),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _teal,
                        disabledBackgroundColor: _teal.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ?  SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        'Submit',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                   SizedBox(height: 260),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}