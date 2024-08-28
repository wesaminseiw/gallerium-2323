import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gallerium/app/utils/extensions.dart';
import 'package:gallerium/logic/services/navigation_service.dart';
import 'package:gallerium/presentation/screens/login_screen.dart';
import 'package:gallerium/presentation/screens/verify_email_screen.dart';
import 'package:gallerium/presentation/styles/border_radius.dart';
import 'package:gallerium/presentation/styles/colors.dart';
import 'package:gallerium/presentation/styles/font_weights.dart';
import 'package:gallerium/presentation/styles/text_shadow.dart';
import 'package:gallerium/presentation/widgets/error_dialog.dart';
import 'package:gallerium/presentation/widgets/sized_boxes.dart';
import 'package:gallerium/presentation/widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
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
                  bottom: 54,
                ),
                child: Row(
                  children: [
                    Text(
                      'Register',
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
                              // check if username is already in use, then check if email is in use.
                              final auth = FirebaseAuth.instance;
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              // check if email exists
                              try {
                                if (emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  final UserCredential userCredential =
                                      await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  String defaultName =
                                      userCredential.user!.email!.split('@')[0];

                                  await userCredential.user!.updateProfile(
                                    displayName: defaultName,
                                  );
                                  await userCredential.user!.reload();
                                  auth.currentUser?.sendEmailVerification();
                                  go(context, const VerifyEmailScreen());
                                } else {
                                  showError(
                                    context,
                                    title: 'Email or password is empty',
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  showError(
                                    context,
                                    title: 'Email already in use',
                                  );
                                } else if (e.code == 'invalid-email') {
                                  showError(
                                    context,
                                    title: 'Invalid email',
                                  );
                                } else if (e.code == 'weak-password') {
                                  showError(
                                    context,
                                    title: 'Weak password',
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
                                  'Register',
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
                            top: 55,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
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
                                        const LoginScreen(),
                                      );
                                    },
                                  text: 'Login.',
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
