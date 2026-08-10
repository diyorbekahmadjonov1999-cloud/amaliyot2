import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [

            // 1-QAVAT:

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
            /////////////////////////////////////////////////////////////////////

            // 2-QAVAT:

            SafeArea(child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        padding:  EdgeInsets.all(10),
                        decoration:  BoxDecoration(
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
                        child:  Icon(
                          Icons.arrow_back,
                          color: Color(0xFF00897B), // AppColors.primary
                        ),
                      ),

                      Container(
                        padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12),
                        ),
                        child:  Row(
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
                  )


                ],
              ),
            ))
          ],
        ),


      ),
    );
  }
}