class ReviewModel {
  final String id;
  final String productId;
  final String name;
  final int score;
  final String description;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.score,
    required this.description,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      score: json['score'] as int,
      description: json['description'] as String,
    );
  }
}
