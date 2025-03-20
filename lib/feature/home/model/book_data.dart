import 'dart:convert';

class BookDataModel {
  final String id;
  final String title;
  final List<String>? authors; // Nullable authors
  final String thumbnail;
  final double? price; // Nullable
  final String publisher;
  final String description;

  BookDataModel({
    required this.id,
    required this.title,
    this.authors, // Nullable
    required this.thumbnail,
    this.price,
    required this.publisher,
    required this.description,
  });

  // Convert JSON to BookDataModel
  factory BookDataModel.fromJson(Map<String, dynamic> json) {
    return BookDataModel(
      id: json['id'],
      title: json['volumeInfo']['title'] ?? 'No Title',
      authors: json['volumeInfo']['authors'] != null
          ? List<String>.from(json['volumeInfo']['authors'])
          : null, // Handle null authors
      thumbnail: json['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
      price: json['saleInfo']?['listPrice']?['amount']?.toDouble(),
      publisher: json['volumeInfo']['publisher'] ?? 'No Publisher',
      description: json['volumeInfo']['description'] ?? 'No Description',
    );
  }

  // Convert BookDataModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors':
          authors != null ? jsonEncode(authors) : null, // Handle null authors
      'thumbnail': thumbnail,
      'price': price,
      'publisher': publisher,
      'description': description,
    };
  }

  // Extract a BookDataModel from a Map (for database operations)
  factory BookDataModel.fromMap(Map<String, dynamic> map) {
    return BookDataModel(
      id: map['id'],
      title: map['title'],
      authors: map['authors'] != null
          ? List<String>.from(jsonDecode(map['authors']))
          : null, // Handle null authors
      thumbnail: map['thumbnail'],
      price: map['price']?.toDouble(),
      publisher: map['publisher'],
      description: map['description'],
    );
  }
}
