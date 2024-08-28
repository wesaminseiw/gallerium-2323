import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallerium/logic/services/timer_service.dart';
import 'package:gallerium/presentation/screens/home_page.dart';
import 'package:gallerium/presentation/screens/login_screen.dart';
import 'package:gallerium/presentation/screens/verify_email_screen.dart';

import 'package:gallerium/presentation/styles/colors.dart';

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (auth.currentUser != null) {
            if (auth.currentUser!.emailVerified) {
              log('SIGNED IN AS: ${auth.currentUser?.email}');
              return const HomePage();
            } else {
              log('SIGNED IN AS (NOT VERIFIED): ${auth.currentUser?.email}');
              return const VerifyEmailScreen();
            }
          } else {
            return const LoginScreen();
          }
        },
      ),
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryColor,
          onPrimary: teritaryColor,
          secondary: secondaryColor,
          onSecondary: quaternaryColor,
          error: Colors.red,
          onError: quaternaryColor,
          surface: teritaryColor,
          onSurface: primaryColor,
        ),
      ),
    );
  }
}
