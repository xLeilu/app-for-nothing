import 'dart:typed_data';

class BookModel {
  final int? id;
  final String title;
  final String author;
  final String category;
  final String description;
  final Uint8List imageBytes;
  final String location;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.imageBytes,
    required this.location,
  });

  factory BookModel.fromMap(Map<String, dynamic> json) => BookModel(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        category: json['category'],
        description: json['description'],
        imageBytes: json['photo'],
        location: json['location'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'photo': imageBytes,
      'location': location,
    };
  }
}
