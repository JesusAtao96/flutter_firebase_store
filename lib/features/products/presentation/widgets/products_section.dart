import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_demo_class/common/widgets/screens/loading_screen.dart';
import 'package:store_demo_class/common/widgets/text_fields/primary_text_field.dart';
import 'package:store_demo_class/features/products/presentation/providers/products_providers.dart';
import 'package:store_demo_class/features/products/presentation/screens/product_detail_screen.dart';
import 'package:store_demo_class/features/products/presentation/widgets/category_item_tab.dart';
import 'package:store_demo_class/features/products/presentation/widgets/product_item_card.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class ProductsSection extends ConsumerWidget {
  final searchProductController = TextEditingController();

  ProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final currentCategoryFilter = ref.watch(categoryFilterProvider);
    final productsAsync = ref.watch(productsProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    if (categoriesAsync.isLoading || productsAsync.isLoading) {
      return const LoadingScreen();
    }

    if (categoriesAsync.hasError) {
      return Center(child: Text('Error: ${categoriesAsync.error}'));
    }

    if (productsAsync.hasError) {
      return Center(child: Text('Error: ${productsAsync.error}'));
    }

    final categoriesList = categoriesAsync.value;
    final productsList = productsAsync.value;

    if (categoriesList == null || productsList == null) {
      return const LoadingScreen();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          PrimaryTextField(
            suffixIcon: Icons.search,
            hintText: 'Buscar productos',
            labelText: 'Buscar productos',
            controller: searchProductController,
            onChanged: (value) {
              ref.read(searchProductsProvider.notifier).state = value.trim();
            },
          ),
          Text('Categorías', style: AppTextStyles.textButtonStyle),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categoriesList[index];
                return CategoryItemTab(
                  category: category,
                  isSelected: currentCategoryFilter == category.id,
                  onTap: () {
                    if (currentCategoryFilter == category.id) {
                      ref.read(categoryFilterProvider.notifier).state = null;
                    } else {
                      ref.read(categoryFilterProvider.notifier).state =
                          category.id;
                    }
                  },
                );
              },
              itemCount: categoriesList.length,
              shrinkWrap: true,
            ),
          ),
          Center(
            child: Text(
              'Todos los Productos',
              style: AppTextStyles.textButtonStyle,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.84,
            ),
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ProductItemCard(
                product: product,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              );
            },
            itemCount: filteredProducts.length,
          ),
        ],
      ),
    );
  }
}
