import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/helper_methods.dart';

class TextFieldWithIcon extends StatelessWidget {
  const TextFieldWithIcon({
    Key? key,
    this.node,
    this.imagePath,
    this.controller,
  }) : super(key: key);

  final FocusNode? node;
  final TextEditingController? controller;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Helper.dynamicWidth(context, 90),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "Email", // Label text
          labelStyle: const TextStyle(
            color: Colors.white, // Label text color
            fontSize: 14,        // Label font size
          ),
          suffixIcon: const Icon(
            Icons.email, // Use email icon
            color: AppColors.btnColor, // Icon color
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[800]!), // Border color
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!), // Focused border color
          ),
          fillColor: AppColors.backgroundColor, // Background color (if necessary)
          filled: true, // Fill background with color
        ),
        style: const TextStyle(
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller; // Controller to access the input
  final String txt;
  PasswordField({required this.controller,required this.txt});
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true; // Initially obscure the password


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Helper.dynamicWidth(context, 90),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured, // Toggle password visibility
        decoration: InputDecoration(
          labelText: widget.txt, // Label text
          labelStyle: const TextStyle(
            color: Colors.white, // Label text color
            fontSize: 14,        // Label font size
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: AppColors.btnColor, // Icon color
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured; // Toggle password visibility
              });
            },
          ),

          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[800]!), // Border color
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!), // Focused border color
          ),
          fillColor: AppColors.backgroundColor, // Background color (if necessary)
          filled: true, // Fill background with color
        ),
        style: const TextStyle(
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  EmailTextField({
    Key? key,
    required this.controller
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: const TextStyle(color: Colors.white), //
            controller: controller,// Text color
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              filled: true,
              fillColor: AppColors.backgroundColor, // Background color
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWithCustomIcon extends StatelessWidget {
  TextFieldWithCustomIcon({
    Key? key,
    this.node,
    required this.icon,
    this.controller,
    required this.label,
  }) : super(key: key);

  final FocusNode? node;
  final TextEditingController? controller;
  final IconData icon;
  String label;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Helper.dynamicWidth(context, 90),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label, // Label text
          labelStyle: const TextStyle(
            color: Colors.white, // Label text color
            fontSize: 14,        // Label font size
          ),
          suffixIcon:  Icon( icon, // Use email icon
            color: AppColors.btnColor, // Icon color
          ),
        ),
        style: const TextStyle(
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}



