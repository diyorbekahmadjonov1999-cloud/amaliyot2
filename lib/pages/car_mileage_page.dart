import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backgrounds/create_account_background.dart';
import '../widgets/create_account_bottom.dart';
import '../widgets/custom_input.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'verify_register_page.dart';

class CarMileagePage extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final int brandId;
  final int carModelId;
  final int carYear;

  const CarMileagePage({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.brandId,
    required this.carModelId,
    required this.carYear,
  });

  @override
  State<CarMileagePage> createState() => _CarMileagePageState();
}

class _CarMileagePageState extends State<CarMileagePage> {
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  String? _mileageError;
  String? _carNumberError;
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _mileageController.dispose();
    _carNumberController.dispose();
    super.dispose();
  }

  // Backendga register so'rovini yuboradi (kod yuborish ham shu orqali)
  Future<http.Response> _sendRegister(int carKm, String carNumber) {
    return AuthService.register(
      fullName: widget.fullName,
      phoneNumber: widget.phoneNumber,
      brandId: widget.brandId,
      carModelId: widget.carModelId,
      carYear: widget.carYear,
      carKm: carKm,
      carNumber: carNumber,
    );
  }

  Future<void> _handleSignUp() async {
    final mileageText = _mileageController.text.trim();
    final carNumberText = _carNumberController.text.trim();

    setState(() {
      if (mileageText.isEmpty) {
        _mileageError = 'Please enter the distance the car has reached.';
      } else if (int.tryParse(mileageText) == null) {
        _mileageError = 'Please enter the distance the car has reached.';
      } else {
        _mileageError = null;
      }

      if (carNumberText.length < 8) {
        _carNumberError = 'Enter the full car number (e.g. 01A123BC).';
      } else {
        _carNumberError = null;
      }
    });

    if (_mileageError != null || _carNumberError != null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final carKm = int.parse(mileageText);

    try {
      final response = await _sendRegister(carKm, carNumberText);
      debugPrint('REGISTER ${response.statusCode}: ${response.body}');
      try {
        final bodyData = jsonDecode(response.body);
        final otpCode = bodyData['otp'] ?? bodyData['code'];
        if (otpCode != null) {
          debugPrint('\n=============================================');
          debugPrint('🔑🔑🔑 ENG YANGI OTP KOD: $otpCode 🔑🔑🔑');
          debugPrint('=============================================\n');
        }
      } catch (_) {}
      if (!mounted) return;

      if (response.statusCode == 200) {
        // Bir martalik kod yuborildi, kod kiritish sahifasiga o'tamiz
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyRegisterPage(
              phoneNumber: widget.phoneNumber,
              onResend: () async {
                final r = await _sendRegister(carKm, carNumberText);
                if (r.statusCode != 200) {
                  throw Exception('Resend failed: ${r.statusCode}');
                }
              },
            ),
          ),
        );
      } else {
        setState(() {
          _submitError = 'Xatolik yuz berdi: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = 'Internetni tekshiring, so\'rov yuborilmadi.';
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

                  CustomInput(
                    label: 'Car reacher (km)',
                    hintText: '12000',
                    controller: _mileageController,
                    keyboardType: TextInputType.number,
                    errorText: _mileageError,
                    onChanged: (_) {
                      if (_mileageError != null) {
                        setState(() => _mileageError = null);
                      }
                    },
                  ),

                  SizedBox(height: 24),

                  CustomInput(
                    label: 'Car number',
                    hintText: '01A123CD',
                    controller: _carNumberController,
                    errorText: _carNumberError,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]'),
                      ),
                      TextInputFormatter.withFunction(
                            (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.toUpperCase(),
                        ),
                      ),
                    ],
                    onChanged: (_) {
                      if (_carNumberError != null) {
                        setState(() => _carNumberError = null);
                      }
                    },
                  ),

                  SizedBox(height: 32),
                  if (_submitError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _submitError!,
                        style: TextStyle(color: Colors.red, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // To'liq kenglikdagi Sign up tugmasi
                  GestureDetector(
                    onTap: _isSubmitting ? null : _handleSignUp,
                    child: Container(
                      width: double.infinity,
                      height: 56,
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
                      child: Center(
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
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