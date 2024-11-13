import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;
  final bool isBookmarked;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.isBookmarked = false,
  });

  Article copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isBookmarked,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, url, imageUrl, publishedAt, isBookmarked];
}
