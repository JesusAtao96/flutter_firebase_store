import 'package:store_demo_class/features/products/domain/models/category_model.dart';
import 'package:store_demo_class/features/products/domain/models/product_model.dart';
import 'package:store_demo_class/features/products/domain/models/review_model.dart';

abstract class ProductsRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByIds(List<String> ids);
  Future<List<ReviewModel>> getReviewsForProduct(String productId);
}
