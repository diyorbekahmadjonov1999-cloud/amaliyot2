import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  // Yangi ixtiyoriy parametrlar (eski chaqiruvlar buzilmaydi)
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.errorText,
    this.keyboardType,
    this.onChanged,
    this.prefixText,
    this.inputFormatters,
  });

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF1D1D1D),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFFB0B0B0),
            ),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D1D1D),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            enabledBorder: _border(
              errorText != null ? Colors.red : const Color(0xFFD0D0D0),
            ),
            focusedBorder: _border(
              errorText != null ? Colors.red : const Color(0xFF00897B),
            ),
            border: _border(const Color(0xFFD0D0D0)),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}