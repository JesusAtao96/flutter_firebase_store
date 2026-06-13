import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:store_demo_class/features/auth/presentation/providers/auth_providers.dart';
import 'package:store_demo_class/features/cart/domain/models/cart_model.dart';
import 'package:store_demo_class/features/products/domain/models/product_model.dart';
import 'package:store_demo_class/features/products/domain/repositories/products_repository.dart';
import 'package:store_demo_class/features/products/presentation/providers/products_providers.dart';

const String _unauthenticatedUserId = 'error';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final cartProvider = StateNotifierProvider<CartNotifier, CartModel>((ref) {
  final user = ref.watch(userProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final productsRepository = ref.watch(productsRepositoryProvider);

  return CartNotifier(
    userId: user.id,
    firestore: firestore,
    productsRepository: productsRepository,
  );
});

class CartNotifier extends StateNotifier<CartModel> {
  final String userId;
  final FirebaseFirestore firestore;
  final ProductsRepository productsRepository;

  CartNotifier({
    required this.userId,
    required this.firestore,
    required this.productsRepository,
  }) : super(CartModel(userId: userId, items: const [])) {
    if (userId != _unauthenticatedUserId) {
      getCart();
    }
  }

  DocumentReference<Map<String, dynamic>> get _cartRef =>
      firestore.collection('carts').doc(userId);

  Future<void> getCart() async {
    if (userId == _unauthenticatedUserId) return;

    state = state.copyWith(isLoading: true);

    try {
      final snapshot = await _cartRef.get();

      if (!snapshot.exists) {
        state = state.copyWith(items: const [], isLoading: false);
        return;
      }

      final data = snapshot.data();
      final rawItems = (data?['items'] as List?) ?? const [];

      final cartItemModels = rawItems
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromMap)
          .toList();

      if (cartItemModels.isEmpty) {
        state = state.copyWith(items: const [], isLoading: false);
        return;
      }

      final productIds = cartItemModels.map((e) => e.productId).toList();
      final products = await productsRepository.getProductsByIds(productIds);
      final productsById = {for (final p in products) p.id: p};

      final items = <CartItem>[];
      for (final cartItem in cartItemModels) {
        final product = productsById[cartItem.productId];
        if (product == null) continue;
        items.add(CartItem(product: product, quantity: cartItem.quantity));
      }

      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> addToCart(ProductModel product) async {
    if (userId == _unauthenticatedUserId) {
      throw StateError(
        'No hay un usuario autenticado para guardar el carrito.',
      );
    }

    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    final updatedItems = List<CartItem>.from(state.items);

    if (existingIndex >= 0) {
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
    } else {
      updatedItems.add(CartItem(product: product, quantity: 1));
    }

    state = state.copyWith(items: updatedItems);
    await _persist();
  }

  Future<void> removeFromCart(String productId) async {
    if (userId == _unauthenticatedUserId) return;

    final updatedItems = state.items
        .where((item) => item.product.id != productId)
        .toList();

    state = state.copyWith(items: updatedItems);
    await _persist();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (userId == _unauthenticatedUserId) return;

    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id != productId) return item;
      return item.copyWith(quantity: quantity);
    }).toList();

    state = state.copyWith(items: updatedItems);
    await _persist();
  }

  bool isProductInCart(String productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  Future<void> _persist() async {
    final payload = {
      'items': state.items
          .map(
            (item) => CartItemModel(
              productId: item.product.id,
              quantity: item.quantity,
            ).toMap(),
          )
          .toList(),
    };

    await _cartRef.set(payload);
  }
}
