import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_demo_class/features/cart/domain/models/cart_model.dart';
import 'package:store_demo_class/features/cart/presentation/providers/cart_providers.dart';
import 'package:store_demo_class/features/cart/presentation/widgets/quantity_stepper.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class CartItemRow extends ConsumerWidget {
  final CartItem item;

  const CartItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    final lineTotal = item.lineTotal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
              placeholder: (_, _) => const SizedBox(width: 74, height: 74),
              errorWidget: (_, _, _) =>
                  const Icon(Icons.image_not_supported, size: 32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: AppTextStyles.textLabelStyle),
                const SizedBox(height: 2),
                Text(
                  'S/ ${item.product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.textDescriptionStyle,
                ),
                const SizedBox(height: 8),
                QuantityStepper(
                  quantity: item.quantity,
                  onDecrement: () => notifier.updateQuantity(
                    item.product.id,
                    item.quantity - 1,
                  ),
                  onIncrement: () => notifier.updateQuantity(
                    item.product.id,
                    item.quantity + 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'S/ ${lineTotal.toStringAsFixed(2)}',
            style: AppTextStyles.textPriceStyle,
          ),
        ],
      ),
    );
  }
}
