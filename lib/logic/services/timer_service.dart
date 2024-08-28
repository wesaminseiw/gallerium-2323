import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

void startTimer() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Timer timer;
  timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
    auth.currentUser?.reload();
    auth.authStateChanges();
    auth.userChanges();
  });
}
