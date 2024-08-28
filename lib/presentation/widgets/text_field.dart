import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallerium/app/utils/extensions.dart';
import 'package:gallerium/presentation/styles/border_radius.dart';
import 'package:gallerium/presentation/styles/colors.dart';

Widget textField({
  required BuildContext context,
  required TextEditingController controller,
  required IconData prefixIcon,
  Widget? helper,
  IconData? suffixIcon,
  Color? suffixIconColor,
  void Function()? suffixOnPressed,
  void Function()? onTap,
  void Function(String value)? onChanged,
  TextInputType? keyboardType,
  bool? obscureText,
  String? obscuringCharacter,
  int? maxLength,
}) =>
    TextField(
      controller: controller,
      style: TextStyle(
        color: secondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? '●',
      onChanged: onChanged,
      onTap: onTap,
      maxLength: maxLength,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: defaultBorderRadius,
        ),
        filled: true,
        fillColor: context.colorScheme.surface,
        helper: helper,
        prefixIcon: Icon(
          prefixIcon,
          color: context.colorScheme.primary,
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: suffixOnPressed ?? () {},
                child: Icon(
                  suffixIcon,
                  color: suffixIconColor ?? Colors.grey,
                ),
              )
            : null,
      ),
    );
