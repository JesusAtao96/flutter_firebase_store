import 'package:flutter/material.dart';
import 'package:store_demo_class/features/cart/presentation/widgets/stepper_button.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StepperButton(icon: Icons.remove, onTap: onDecrement),
          Text('$quantity', style: AppTextStyles.textPriceStyle),
          StepperButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}
