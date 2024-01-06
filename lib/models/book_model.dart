class BookModel {
  final int? id;
  final String title;
  final String author;
  final String description;

  BookModel(
      {this.id,
      required this.title,
      required this.author,
      required this.description});

  factory BookModel.fromMap(Map<String, dynamic> json) => BookModel(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
    };
  }
}
