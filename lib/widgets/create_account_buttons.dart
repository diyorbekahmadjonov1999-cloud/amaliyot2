import 'package:flutter/material.dart';

class CreateAccountButtons extends StatelessWidget {
  final double continueWidth;
  final double continueHeight;

  const CreateAccountButtons({
    super.key,
    this.continueWidth = 220,
    this.continueHeight = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Chapdagi button
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color:  Color(0xFF909090),
              width: 1,
            ),
            boxShadow:  [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child:  Icon(
            Icons.layers_clear_outlined,
            color: Color(0xFF909090),
            size: 24,
          ),
        ),

         SizedBox(width: 20),

        // Continue button
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color:  Color(0xFF009577),
              borderRadius: BorderRadius.circular(999),
              boxShadow:  [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: 0,
                    color:  Color(0xFFF0EBE5),
                  ),
                ),
                 SizedBox(width: 10),
                 Icon(
                  Icons.arrow_forward,
                  color: Color(0xFFF0EBE5),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
