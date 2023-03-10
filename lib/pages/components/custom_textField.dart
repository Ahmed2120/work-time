import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
        this.keyboardType=TextInputType.text,
        this.icon,
        this.prefixIcon,
        this.hint,
        this.isPassword = false,
        this.border=10,this.focusBorder=10,
      required TextEditingController controller,this.label, this.isNumeric = false})
      : _controller = controller;

  final TextEditingController _controller;
  final String? label;
  final bool isNumeric;
  final bool isPassword;
  final TextInputType keyboardType;
  final double border;
  final double focusBorder;
  final Widget? icon;
  final Widget? prefixIcon;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        style: const TextStyle(color: Color(0xFF0F3460),fontSize: 16),
        controller: _controller,
        textDirection: TextDirection.rtl,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.text ? null : [
          FilteringTextInputFormatter.allow(
            RegExp('[0-9]'),
          ),
        ],
        obscureText: isPassword,
        decoration: InputDecoration(
          prefix:prefixIcon,
            suffix: icon,
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            filled: true,
            fillColor: const Color(0xF9D5CFCF).withOpacity(.3),
            labelText: label,
            hintStyle:const TextStyle(fontSize: 18, color: Color(0xFF0F3460)),
            labelStyle:const TextStyle(fontSize: 18, color: Color(0xFF0F3460)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(10)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(15))),
        validator: (val) {
          if (_controller.text.isEmpty) {
            return ' ???? ???????? ???????? $label';
          }
        },
      ),
    );
  }
}
