import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? errorText;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.errorText,
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
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF1D1D1D),
            ),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
            decoration: InputDecoration(
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
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            hint: Text(
              hintText,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFB5B5BA),
              ),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
                .toList(),
            onChanged: onChanged,
          ),
        ),

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