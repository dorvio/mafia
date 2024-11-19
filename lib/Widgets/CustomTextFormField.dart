import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final String labelText;
  final int? maxLines;
  final int? maxLength;
  final String? initialValue;

  const CustomTextFormField({
    Key? key,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixIcon = null,
    this.labelText = 'Wpisz tutaj',
    this.maxLines = null,
    this.maxLength = null,
    this.initialValue = null,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      maxLines: widget.maxLines,
      maxLength : widget.maxLength,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white),
        counterStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 186, 86, 36), width: 3),
          borderRadius: BorderRadius.circular(30.0),
        ),
        filled: true,
        fillColor: Colors.grey[900],
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 186, 86, 36), width: 3),
          borderRadius: BorderRadius.circular(30.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: widget.prefixIcon,
        prefixIconColor: Colors.white,
      ),
      validator: widget.validator ?? (text) {
        return null;
      },
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}