class BookShortModel {
  final int? id;
  final String title;
  final String author;
  final String category;
  final String description;

  BookShortModel({
    this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
  });

  factory BookShortModel.fromMap(Map<String, dynamic> json) => BookShortModel(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        category: json['category'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
    };
  }
}
