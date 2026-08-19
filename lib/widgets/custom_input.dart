import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String hintText;

  const CustomInput({
    super.key,
    required this.label,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  TextStyle(
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
            style:  TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:  TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFB5B5BA),
              ),

              // Matnni ramka ichida ushlab turadi
              contentPadding:  EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:  BorderSide(
                  color: Color(0xFFC7C7CC),
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:  BorderSide(
                  color: Color(0xFFC7C7CC),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}