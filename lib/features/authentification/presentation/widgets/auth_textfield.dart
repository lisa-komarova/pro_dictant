import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final bool isHidden;
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.validator,
    this.isHidden = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isHidden;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enableSuggestions: !widget.isHidden,
        autocorrect: !widget.isHidden,
        obscureText: _isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 11),
          suffixIcon: widget.isHidden
              ? IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              size: 18,
              color: _isObscured ? null : Color(0xFF85977F),
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          )
              : null,
        ),
        validator: widget.validator,
      ),
    );
  }
}
