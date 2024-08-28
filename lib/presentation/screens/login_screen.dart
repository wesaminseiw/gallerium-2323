import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gallerium/app/utils/extensions.dart';
import 'package:gallerium/logic/services/navigation_service.dart';
import 'package:gallerium/presentation/screens/home_page.dart';
import 'package:gallerium/presentation/screens/register_screen.dart';
import 'package:gallerium/presentation/screens/verify_email_screen.dart';
import 'package:gallerium/presentation/styles/border_radius.dart';
import 'package:gallerium/presentation/styles/colors.dart';
import 'package:gallerium/presentation/styles/font_weights.dart';
import 'package:gallerium/presentation/styles/text_shadow.dart';
import 'package:gallerium/presentation/widgets/error_dialog.dart';
import 'package:gallerium/presentation/widgets/sized_boxes.dart';
import 'package:gallerium/presentation/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 133,
                  bottom: 56,
                ),
                child: Row(
                  children: [
                    Text(
                      'Login',
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
                            top: 36,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Your email address',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: semiBold,
                                      fontSize: 16,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              height(10),
                              textField(
                                context: context,
                                controller: emailController,
                                prefixIcon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 16,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Your password',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: semiBold,
                                      fontSize: 16,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              height(10),
                              textField(
                                context: context,
                                controller: passwordController,
                                prefixIcon: Icons.lock_outline_rounded,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 46,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final auth = FirebaseAuth.instance;
                              final email = emailController.text;
                              final password = passwordController.text;

                              try {
                                if (emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  await auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (auth.currentUser!.emailVerified) {
                                    go(context, const HomePage());
                                  } else {
                                    go(context, const VerifyEmailScreen());
                                  }
                                } else {
                                  showError(
                                    context,
                                    title: 'Email or password is empty',
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'wrong-password' ||
                                    e.code == 'user-not-found') {
                                  showError(
                                    context,
                                    title: 'Wrong credentials',
                                  );
                                } else if (e.code == 'invalid-email') {
                                  showError(
                                    context,
                                    title: 'Invalid email',
                                  );
                                } else {
                                  showError(
                                    context,
                                    title: 'An error occurred',
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: defaultBorderRadius,
                                color: context.colorScheme.primary,
                              ),
                              child: Center(
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: quaternaryColor,
                                    fontWeight: bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 61,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: semiBold,
                              ),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      push(
                                        context,
                                        const RegisterScreen(),
                                      );
                                    },
                                  text: 'Register now.',
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ],
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
}
