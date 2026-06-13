import 'package:flutter/material.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Icon? icon;
  final double? horizontal;
  final double? vertical;
  final VoidCallback? onTap;

  const PrimaryButton({
    super.key,
    this.text,
    this.icon,
    this.horizontal = 16.0,
    this.vertical = 12.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontal!,
            vertical: vertical!,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                if (icon != null && text != null) const SizedBox(width: 8),
                if (text != null)
                  Text(
                    text.toString(),
                    style: AppTextStyles.primaryButtonTextStyle,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
