import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInput({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.prefixText,
    this.inputFormatters,
  });

  static const Color _errorColor = Color(0xFFFF5A5A);
  static const Color _defaultBorderColor = Color(0xFFC7C7CC);

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final Color borderColor = hasError ? _errorColor : _defaultBorderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF1D1D1D),
          ),
        ),

        SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFB5B5BA),
              ),

              // Telefon uchun doim ko'rinadigan "+998 " prefiksi
              prefixText: prefixText,
              prefixStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1D1D1D),
              ),

              // Matnni ramka ichida ushlab turadi
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),

        // Xato matni
        if (hasError) ...[
          SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _errorColor,
            ),
          ),
        ],
      ],
    );
  }
}