import 'package:hive/hive.dart';
import 'package:precise/domain/entities/article.dart';
part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime publishedAt;

  @HiveField(6)
  final bool isBookmarked;

  @HiveField(7)
  final String category;

  ArticleModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.isBookmarked = false,
  });

  // Factory constructor to create an ArticleModel from JSON
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['webTitle'],
      category: json['sectionName'],
      description: json['fields']?['trailText'] ?? '',
      url: json['webUrl'],
      imageUrl: json['fields']?['thumbnail'],
      publishedAt: DateTime.parse(json['webPublicationDate']),
    );
  }

  // Convert ArticleModel to an Article entity for the domain layer
  Article toEntity() {
    return Article(
      id: id,
      title: title,
      category: category,
      description: description,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      isBookmarked: isBookmarked,
    );
  }

  // Factory constructor to create an ArticleModel from an Article entity
  factory ArticleModel.fromEntity(Article entity) {
    return ArticleModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      description: entity.description,
      url: entity.url,
      imageUrl: entity.imageUrl,
      publishedAt: entity.publishedAt,
      isBookmarked: entity.isBookmarked,
    );
  }

  // CopyWith method for immutability
  ArticleModel copyWith({
    bool? isBookmarked,
  }) {
    return ArticleModel(
      id: id,
      title: title,
      category: category,
      description: description,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}


// @HiveType(typeId: 0)
// class ArticleModel extends HiveObject {
//   @HiveField(0)
//   final String id;

//   @HiveField(1)
//   final String title;

//   @HiveField(2)
//   final String description;

//   @HiveField(3)
//   final String content;

//   @HiveField(4)
//   final String imageUrl;

//   @HiveField(5)
//   final String source;

//   @HiveField(6)
//   final DateTime publishedAt;

//   @HiveField(7)
//   final String url;

//   @HiveField(8)
//   final bool isBookmarked;

//   ArticleModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.content,
//     required this.imageUrl,
//     required this.source,
//     required this.publishedAt,
//     required this.url,
//     this.isBookmarked = false,
//   });

//   factory ArticleModel.fromJson(Map<String, dynamic> json) {
//     return ArticleModel(
//       id: json['id'] ?? '',
//       title: json['webTitle'] ?? '',
//       description: json['fields']?['trailText'] ?? '',
//       content: json['fields']?['bodyText'] ?? '',
//       imageUrl: json['fields']?['thumbnail'] ?? '',
//       source: json['sectionName'] ?? '',
//       publishedAt: DateTime.parse(json['webPublicationDate']),
//       url: json['webUrl'] ?? '',
//     );
//   }

//   factory ArticleModel.fromEntity(Article article) {
//     return ArticleModel(
//       id: article.id,
//       title: article.title,
//       description: article.description,
//       content: article.content,
//       imageUrl: article.imageUrl,
//       source: article.source,
//       publishedAt: article.publishedAt,
//       url: article.url,
//       isBookmarked: article.isBookmarked,
//     );
//   }

//   Article toEntity() {
//     return Article(
//       id: id,
//       title: title,
//       description: description,
//       content: content,
//       imageUrl: imageUrl,
//       source: source,
//       publishedAt: publishedAt,
//       url: url,
//       isBookmarked: isBookmarked,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'content': content,
//       'urlToImage': imageUrl,
//       'source': {'name': source},
//       'publishedAt': publishedAt.toIso8601String(),
//       'url': url,
//       'isBookmarked': isBookmarked,
//     };
//   }

//   ArticleModel copyWith({
//     bool? isBookmarked,
//   }) {
//     return ArticleModel(
//       id: id,
//       title: title,
//       description: description,
//       content: content,
//       imageUrl: imageUrl,
//       source: source,
//       publishedAt: publishedAt,
//       url: url,
//       isBookmarked: isBookmarked ?? this.isBookmarked,
//     );
//   }
// }
