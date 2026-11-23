
import 'package:flutter/material.dart';

class CustemTextFormField extends StatefulWidget {
  const CustemTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.showPasswordToggle = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.borderRadius = 12,
    this.fillColor,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool isPassword;
  final bool showPasswordToggle;
  final bool enabled;
  final bool readOnly;

  final int maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;

  final double borderRadius;
  final Color? fillColor;

  @override
  State<CustemTextFormField> createState() =>
      _CustemTextFormFieldState();
}

class _CustemTextFormFieldState
    extends State<CustemTextFormField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      textInputAction: widget.textInputAction,

      obscureText: widget.isPassword && isObscure,

      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,

        prefixIcon: widget.prefixIcon,

        suffixIcon: widget.showPasswordToggle &&
                widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              )
            : widget.suffixIcon,

        filled: widget.fillColor != null,
        fillColor: widget.fillColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
