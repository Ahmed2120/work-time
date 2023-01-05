import 'package:flutter/material.dart';

  SizedBox customTextField({
  required TextEditingController controller,required String label,TextInputType keyboardType=TextInputType.text
}) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            prefixIconColor: const Color(0xFF007C6D),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            filled: true,
            fillColor: const Color(0xFF007C6D).withOpacity(0.09),
            label: Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
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
          if (controller.text.isEmpty) {
            return 'please type $label';
          }
        },
      ),
    );
  }

