import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountBackground extends StatelessWidget {
  const CreateAccountBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/svg/yuqori_orta.svg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          child: SvgPicture.asset(
            'assets/svg/birinchi_yuqori.svg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/svg/aylana1.svg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/svg/aylana2.svg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/svg/aylana3.svg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          child: SvgPicture.asset(
            'assets/svg/pastgi_chap.svg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          bottom: 0,
          left: 25,
          child: SvgPicture.asset(
            'assets/svg/pastgi_chap2.svg',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}