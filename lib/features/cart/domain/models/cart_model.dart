import 'package:store_demo_class/features/products/domain/models/product_model.dart';

class CartItemModel {
  final String productId;
  final int quantity;

  const CartItemModel({required this.productId, required this.quantity});

  CartItemModel copyWith({String? productId, int? quantity}) {
    return CartItemModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'productId': productId, 'quantity': quantity};
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as String,
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}

class CartItem {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get lineTotal => product.price * quantity;

  CartItem copyWith({ProductModel? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartModel {
  final String userId;
  final List<CartItem> items;
  final bool isLoading;

  const CartModel({
    required this.userId,
    required this.items,
    this.isLoading = false,
  });

  int get totalQuantity =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  CartModel copyWith({
    String? userId,
    List<CartItem>? items,
    bool? isLoading,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
