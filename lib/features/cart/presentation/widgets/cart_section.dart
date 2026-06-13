import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_demo_class/features/cart/presentation/providers/cart_providers.dart';
import 'package:store_demo_class/features/cart/presentation/widgets/cart_item_row.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class CartSection extends ConsumerWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    if (cart.isLoading && cart.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cart.items.isEmpty) {
      return Center(
        child: Text(
          'Tu carrito está vacío',
          style: AppTextStyles.textDescriptionStyle,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cart.items.length,
            separatorBuilder: (_, _) =>
                const Divider(color: Colors.black, thickness: 0.5),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return CartItemRow(item: item);
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'IR A PAGAR  S/ ${cart.subtotal.toStringAsFixed(2)}',
                  style: AppTextStyles.primaryButtonTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
