import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:store_demo_class/features/products/data/products_repository_impl.dart';
import 'package:store_demo_class/features/products/domain/models/category_model.dart';
import 'package:store_demo_class/features/products/domain/models/product_model.dart';
import 'package:store_demo_class/features/products/domain/models/review_model.dart';
import 'package:store_demo_class/features/products/domain/repositories/products_repository.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return ProductsRepositoryImpl(firestore: firestore);
});

// Categorias

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.getCategories();
});

final categoryFilterProvider = StateProvider<String?>((ref) => null);

// Productos

final searchProductsProvider = StateProvider<String>((ref) => '');

final productsProvider = FutureProvider<List<ProductModel>>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.getProducts();
});

final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);
  final searchFilter = ref.watch(searchProductsProvider).toLowerCase().trim();

  if (productsAsync.isLoading || productsAsync.hasError) {
    return [];
  }

  final productsList = productsAsync.value;

  if (productsList == null) {
    return [];
  }

  return productsList.where((product) {
    final matchesCategory =
        categoryFilter == null || product.categoryId == categoryFilter;

    final matchesSearch =
        searchFilter.isEmpty ||
        product.name.toLowerCase().contains(searchFilter);

    return matchesCategory && matchesSearch;
  }).toList();
});

// Reseñas

final reviewsProvider = FutureProvider.family<List<ReviewModel>, String>((
  ref,
  productId,
) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.getReviewsForProduct(productId);
});
