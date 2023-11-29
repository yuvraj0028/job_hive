import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final double width;
  const AuthTextField(
      {required this.hintText,
      required this.prefixIcon,
      required this.controller,
      required this.isPassword,
      required this.width,
      super.key});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: const TextStyle(fontSize: 16),
        obscureText: widget.isPassword ? !isVisible : false,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 16),
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 25,
          ),
          prefixIconColor: Colors.grey,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => setState(() {
                    isVisible = !isVisible;
                  }),
                  icon: isVisible
                      ? const Icon(
                          Icons.visibility_off,
                          size: 25,
                        )
                      : const Icon(
                          Icons.visibility,
                          size: 25,
                        ),
                )
              : null,
          suffixIconColor: Colors.grey,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
