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
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: hintText, // floating label
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 16,
        ),
        fillColor: Colors.black.withOpacity(0.1),
        filled: true,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.white),
        ),
        suffixIcon: suffixIcon != null
            ? Theme(
                data: ThemeData(
                  iconTheme: IconThemeData(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: suffixIcon!,
              )
            : null,
      ),
      validator: validator,
    );
  }
}
