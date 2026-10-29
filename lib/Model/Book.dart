class Book {
  final String id;
  final String title;
  final String author;
  final double replacementPrice;
  int totalQuantity;      
  int availableQuantity;  

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    required this.totalQuantity,
    required this.availableQuantity,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      replacementPrice: (json['replacementPrice'] as num).toDouble(),
      totalQuantity: json['totalQuantity'] as int? ?? 1,
      availableQuantity: json['availableQuantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'replacementPrice': replacementPrice,
      'totalQuantity': totalQuantity,
      'availableQuantity': availableQuantity,
    };
  }
}