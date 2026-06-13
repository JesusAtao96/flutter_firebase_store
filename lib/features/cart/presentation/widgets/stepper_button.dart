import 'package:flutter/material.dart';
import 'package:store_demo_class/styles/app_colors.dart';

class StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const StepperButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.backgroundColor, size: 16),
        ),
      ),
    );
  }
}
