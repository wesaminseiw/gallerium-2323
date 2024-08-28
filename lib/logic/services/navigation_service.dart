import 'package:flutter/material.dart';

Future push(
  BuildContext context,
  Widget page,
) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

Future go(
  BuildContext context,
  Widget page,
) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
