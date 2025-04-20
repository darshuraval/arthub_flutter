import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.borderRadius = 30.0,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: suffixIcon != null
              ? Theme(
                  data: ThemeData(
                    iconTheme: IconThemeData(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  child: suffixIcon!,
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
} 