import 'package:flutter/material.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final IconData? suffixIcon;

  const PrimaryTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.controller,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.neutralColor.withValues(alpha: 0.40),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          hint: Text(hintText, style: AppTextStyles.textHintStyle),
          label: Text(labelText, style: AppTextStyles.textLabelStyle),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AppColors.neutralColor)
              : null,
        ),
        style: AppTextStyles.textFieldStyle,
        keyboardType: keyboardType,
        obscureText: isPassword,
        onChanged: onChanged,
      ),
    );
  }
}
