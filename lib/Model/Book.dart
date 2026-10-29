class Book {
  final String id;
  final String title;
  final String author;
  final int replacementPrice;
  final int totalQuantity;
  int availableQuantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    required this.totalQuantity,
    int? availableQuantity,
  }) : availableQuantity = availableQuantity ?? totalQuantity;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'] as String,
      author: json['author'] as String,
      replacementPrice: (json['replacementPrice'] as num).toInt(),
      totalQuantity: (json['totalQuantity'] as num).toInt(),
      availableQuantity: (json['availableQuantity'] as num?)?.toInt(),
    );
  }
}