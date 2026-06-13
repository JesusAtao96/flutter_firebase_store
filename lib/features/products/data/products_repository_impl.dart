import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_demo_class/features/products/domain/models/category_model.dart';
import 'package:store_demo_class/features/products/domain/models/product_model.dart';
import 'package:store_demo_class/features/products/domain/models/review_model.dart';
import 'package:store_demo_class/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final FirebaseFirestore firestore;

  ProductsRepositoryImpl({required this.firestore});

  ProductModel _mapProduct(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      categoryId: data['category_id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),
      imageUrl: data['image_url'] ?? '',
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await firestore.collection('categories').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CategoryModel(
        id: doc.id,
        name: data['name'] ?? '',
        imageUrl: data['image_url'] ?? '',
      );
    }).toList();
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await firestore.collection('products').get();

    return snapshot.docs.map((doc) => _mapProduct(doc.id, doc.data())).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    // Firestore limita `whereIn` a 30 valores por consulta, así que partimos en chunks.
    const int chunkSize = 30;
    final List<ProductModel> results = [];

    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk = ids.sublist(
        i,
        i + chunkSize > ids.length ? ids.length : i + chunkSize,
      );

      final snapshot = await firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      results.addAll(
        snapshot.docs.map((doc) => _mapProduct(doc.id, doc.data())),
      );
    }

    return results;
  }

  @override
  Future<List<ReviewModel>> getReviewsForProduct(String productId) {
    return firestore
        .collection('reviews')
        .where('product_id', isEqualTo: productId)
        .get()
        .then((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ReviewModel(
              id: doc.id,
              productId: productId,
              name: data['name'] ?? '',
              score: (data['score'] as num).toInt(),
              description: data['description'] ?? '',
            );
          }).toList();
        });
  }
}
