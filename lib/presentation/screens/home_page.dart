import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallerium/app/utils/extensions.dart';
import 'package:gallerium/presentation/styles/colors.dart';
import 'package:gallerium/presentation/styles/font_weights.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Hello, ',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: medium,
              fontSize: 20,
            ),
            children: [
              TextSpan(
                text: auth.currentUser!.displayName,
                style: TextStyle(
                  color: context.colorScheme.primary,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                'assets/images/settings.png',
                scale: 5,
              ),
            ),
          ),
        ],
        toolbarHeight: 80,
        elevation: 6,
        backgroundColor: quaternaryColor,
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 34,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(50),
              elevation: 4,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: quaternaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
