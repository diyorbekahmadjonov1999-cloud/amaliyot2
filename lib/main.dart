
import 'package:amaliyot2/pages/create_account_page.dart';
import 'package:amaliyot2/pages/home_page.dart';
import 'package:amaliyot2/pages/main_page.dart';
import 'package:amaliyot2/pages/profile_page.dart';
import 'package:amaliyot2/pages/sign_in_page.dart';
import 'package:amaliyot2/pages/verify_sign_in_page.dart';
import 'package:flutter/material.dart';

void main (){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}
