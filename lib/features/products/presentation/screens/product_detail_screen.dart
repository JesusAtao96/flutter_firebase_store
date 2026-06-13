import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_demo_class/common/widgets/buttons/primary_button.dart';
import 'package:store_demo_class/common/widgets/screens/loading_screen.dart';
import 'package:store_demo_class/features/cart/presentation/providers/cart_providers.dart';
import 'package:store_demo_class/features/products/domain/models/product_model.dart';
import 'package:store_demo_class/features/products/presentation/providers/products_providers.dart';
import 'package:store_demo_class/features/products/presentation/widgets/review_item_card.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class ProductDetailScreen extends ConsumerWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsProvider(product.id));

    if (reviewsAsync.isLoading) {
      return const LoadingScreen();
    }

    if (reviewsAsync.hasError) {
      return Center(child: Text('Error: ${reviewsAsync.error}'));
    }

    final reviewsList = reviewsAsync.value;

    if (reviewsList == null) {
      return const LoadingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          product.name,
          style: AppTextStyles.textProductBarTitleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: product.imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.textProductStyle,
                            ),
                            Text(
                              'S/ ${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.textPriceStyle,
                            ),
                          ],
                        ),
                      ),
                      PrimaryButton(
                        horizontal: 35.0,
                        vertical: 6.0,
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                          color: AppColors.backgroundColor,
                        ),
                        onTap: () async {
                          try {
                            await ref
                                .read(cartProvider.notifier)
                                .addToCart(product);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Producto agregado al carrito!"),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Error al agregar al carrito: $e",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Text(
                    product.description,
                    style: AppTextStyles.textDescriptionStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reseñas (${reviewsList.length})',
                    style: AppTextStyles.textButtonStyle,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 600,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: reviewsList.length,
                      itemBuilder: (context, index) {
                        final review = reviewsList[index];
                        return ReviewItemCard(review: review);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
