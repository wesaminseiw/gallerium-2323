import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallerium/app/utils/extensions.dart';
import 'package:gallerium/presentation/screens/home_page.dart';
import 'package:gallerium/presentation/screens/login_screen.dart';
import 'package:gallerium/presentation/styles/border_radius.dart';
import 'package:gallerium/presentation/styles/colors.dart';
import 'package:gallerium/presentation/styles/font_weights.dart';
import 'package:gallerium/presentation/styles/text_shadow.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      try {
        await auth.currentUser?.reload();
        if (auth.currentUser?.emailVerified ?? false) {
          timer.cancel();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        }
      } catch (e) {
        log('Error during email verification: $e');
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (auth.currentUser != null) {
          final String? username = auth.currentUser!.displayName;
          if (auth.currentUser!.emailVerified) {
            log('SIGNED IN AS: ${auth.currentUser?.email}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              }
            });
          } else {
            log('SIGNED IN AS (NOT VERIFIED): ${auth.currentUser?.email}');
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 131,
                          bottom: 54,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Verify',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: bold,
                                fontSize: 52,
                                color: context.colorScheme.primary,
                                shadows: textShadow,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 430,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: defaultBorderRadius,
                          ),
                          child: Card(
                            elevation: 4,
                            color: quaternaryColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 64,
                                  ),
                                  child: Text(
                                    'Waiting for verification to continue...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: semiBold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 97.5,
                                    right: 97.5,
                                    top: 50,
                                  ),
                                  child: Image.asset(
                                    'assets/images/emails.png',
                                    width: 148,
                                    height: 148,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 35,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Verification has been sent to',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: semiBold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        auth.currentUser!.email.toString(),
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    startTimer();
                                  },
                                  child: Text(
                                    'Check Verification',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          });
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
