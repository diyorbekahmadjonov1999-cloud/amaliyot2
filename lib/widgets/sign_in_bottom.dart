import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/create_account_page.dart';

class SignInBottom extends StatelessWidget {
  const SignInBottom({super.key});

  static const double _figmaWidth = 393;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / _figmaWidth;

    return ClipRect(
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          width: 295,
          height: 404,
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              // DON'T HAVE AN ACCOUNT?

              Positioned(
                left: 0,
                top: 290,
                child: _RotatedText(),
              ),


              // SIGN UP BUTTON

              Positioned(
                left: 40,
                bottom: 60,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountPage(),
                      ),
                    );
                  },
                  child: _RotatedSignUpButton(),
                ),
              ),

              Positioned(
                left: -15,
                bottom: -20,
                child: _CurvedArrowIcon(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _RotatedText extends StatelessWidget {
  const _RotatedText();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 3.75,
      child: SizedBox(
        width: 267,
        height: 20,
        child: FittedBox(
          child: Text(
            "DON'T HAVE AN ACCOUNT?",
            textAlign: TextAlign.center,
            style: GoogleFonts.brunoAceSc(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 20 / 16,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _RotatedSignUpButton extends StatelessWidget {
  const _RotatedSignUpButton();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 3.8,
      child: Container(
        width: 129.53,
        height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Color(0xFF009577),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'Sign up',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 20 / 16,
              letterSpacing: 0,
              color: Color(0xFF009577),
            ),
          ),
        ),
      ),
    );
  }
}

class _CurvedArrowIcon extends StatelessWidget {
  const _CurvedArrowIcon();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 12,
      child: SvgPicture.asset(
        'assets/svg/vector.svg',
        width: 71.15,
        height: 96.72,
      ),
    );
  }
}