// import 'package:hive/hive.dart';
// import 'package:precise/data/models/article_model.dart';

// abstract class ArticleLocalDataSource {
//   Future<List<ArticleModel>> getBookmarkedArticles();
//   Future<void> toggleBookmark(ArticleModel article);
//   Future<void> cacheArticles(List<ArticleModel> articles);
//   Future<List<ArticleModel>> getCachedArticles();
// }

// class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
//   final Box<ArticleModel> articleBox;
//   final Box<ArticleModel> bookmarkBox;

//   ArticleLocalDataSourceImpl({
//     required this.articleBox,
//     required this.bookmarkBox,
//   });

//   @override
//   Future<List<ArticleModel>> getBookmarkedArticles() async {
//     return bookmarkBox.values.toList();
//   }

//   @override
//   Future<void> toggleBookmark(ArticleModel article) async {
//     if (bookmarkBox.containsKey(article.id)) {
//       await bookmarkBox.delete(article.id);
//     } else {
//       await bookmarkBox.put(article.id, article.copyWith(isBookmarked: true));
//     }
//   }

//   @override
//   Future<void> cacheArticles(List<ArticleModel> articles) async {
//     await articleBox.clear();
//     final articlesMap = {for (var article in articles) article.id: article};
//     await articleBox.putAll(articlesMap);
//   }

//   @override
//   Future<List<ArticleModel>> getCachedArticles() async {
//     return articleBox.values.toList();
//   }
// }

import 'package:hive_flutter/hive_flutter.dart';
import 'package:precise/core/errors/exceptions.dart';
import 'package:precise/data/models/article_model.dart';

// data/datasources/article_local_data_source.dart
abstract class ArticleLocalDataSource {
  Future<List<ArticleModel>> getBookmarkedArticles();
  Future<ArticleModel> toggleBookmark(ArticleModel article);
  Future<void> cacheArticles(List<ArticleModel> articles, String? category);
  Future<List<ArticleModel>?> getCachedArticles(String? category);
  Future<bool> isCacheValid(String? category);
}

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final Box<ArticleModel> articleBox;
  final Box<dynamic> cacheBox;
  final Box<bool> bookmarkBox; // Box baru khusus untuk bookmark
  static const cacheValidDuration = Duration(hours: 1);

  ArticleLocalDataSourceImpl({
    required this.articleBox,
    required this.cacheBox,
    required this.bookmarkBox,
  });

  String _getCacheKey(String? category) => 'articles_${category ?? 'all'}';
  String _getCacheTimestampKey(String? category) =>
      'timestamp_${category ?? 'all'}';

  @override
  Future<List<ArticleModel>> getBookmarkedArticles() async {
    try {
      // Ambil semua ID artikel yang di-bookmark
      final bookmarkedIds = bookmarkBox.keys
          .where((key) => bookmarkBox.get(key) == true)
          .toList();

      // Ambil artikel yang sesuai dengan ID bookmark
      final bookmarkedArticles = bookmarkedIds
          .map((id) => articleBox.get(id))
          .whereType<ArticleModel>()
          .map((article) => article.copyWith(
              isBookmarked: true)) // Pastikan status bookmark selalu true
          .toList();

      return bookmarkedArticles;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<ArticleModel> toggleBookmark(ArticleModel article) async {
    try {
      // Update status bookmark di bookmarkBox
      final isBookmarked = !(bookmarkBox.get(article.id) ?? false);
      await bookmarkBox.put(article.id, isBookmarked);

      // Update artikel dengan status bookmark yang baru
      final updatedArticle = article.copyWith(isBookmarked: isBookmarked);
      await articleBox.put(article.id, updatedArticle);

      return updatedArticle;
    } catch (e) {
      throw CacheException('Error toggling bookmark: ${e.toString()}');
    }
  }

  @override
  Future<List<ArticleModel>?> getCachedArticles(String? category) async {
    try {
      final cacheKey = _getCacheKey(category);
      final articleIds = cacheBox.get(cacheKey) as List?;

      if (articleIds == null) return null;

      // Selalu gunakan status bookmark dari bookmarkBox
      return articleIds
          .map((id) {
            final article = articleBox.get(id);
            if (article == null) return null;

            final isBookmarked = bookmarkBox.get(id) ?? false;
            return article.copyWith(isBookmarked: isBookmarked);
          })
          .whereType<ArticleModel>()
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheArticles(
      List<ArticleModel> articles, String? category) async {
    try {
      final cacheKey = _getCacheKey(category);
      final timestampKey = _getCacheTimestampKey(category);

      // Simpan artikel dengan mempertahankan status bookmark yang ada
      for (var article in articles) {
        final existingBookmark = bookmarkBox.get(article.id) ?? false;
        final articleToCache = article.copyWith(isBookmarked: existingBookmark);
        await articleBox.put(article.id, articleToCache);
      }

      await cacheBox.put(cacheKey, articles.map((e) => e.id).toList());
      await cacheBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> isCacheValid(String? category) async {
    try {
      final timestampKey = _getCacheTimestampKey(category);
      final timestamp = cacheBox.get(timestampKey) as int?;

      if (timestamp == null) return false;

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cachedTime) <= cacheValidDuration;
    } catch (e) {
      return false;
    }
  }
}



// abstract class ArticleLocalDataSource {
//   Future<List<ArticleModel>> getCachedArticles(String category);
//   Future<void> cacheArticles(String category, List<ArticleModel> articles);
//   Future<bool> isCacheValid(String category, Duration maxCacheAge);
//   Future<List<ArticleModel>> getBookmarkedArticles();
//   Future<void> toggleBookmark(ArticleModel article);
// }

// class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
//   final Box<ArticleModel> articlesBox;
//   final Box cacheConfigBox;

//   ArticleLocalDataSourceImpl({
//     required this.articlesBox,
//     required this.cacheConfigBox,
//   });

//   @override
//   Future<List<ArticleModel>> getCachedArticles(String category) async {
//     try {
//       // Filter to retrieve only articles for the specified category
//       final categoryArticles = articlesBox.values.where((article) {
//         final articleKey = articlesBox
//             .keyAt(articlesBox.values.toList().indexOf(article)) as String;
//         return articleKey.startsWith('category_$category');
//       }).toList();

//       return categoryArticles.cast<ArticleModel>();
//     } catch (e) {
//       throw CacheException(
//           'Failed to retrieve cached articles for category: $category');
//     }
//   }

//   @override
//   Future<void> cacheArticles(
//       String category, List<ArticleModel> articles) async {
//     try {
//       // Clear previous articles for this category
//       final keysToDelete = articlesBox.keys
//           .where((key) => key.toString().startsWith('category_$category'))
//           .toList();
//       await articlesBox.deleteAll(keysToDelete);

//       // Store each article with a unique key for the category
//       for (var article in articles) {
//         final key = 'category_${category}_${article.id}';
//         await articlesBox.put(key, article);
//       }

//       // Store the cache time for this category
//       await cacheConfigBox.put(
//           'cacheTime_$category', DateTime.now().millisecondsSinceEpoch);
//     } catch (e) {
//       throw CacheException('Failed to cache articles for category: $category');
//     }
//   }

//   @override
//   Future<bool> isCacheValid(String category, Duration maxCacheAge) async {
//     try {
//       final cacheTime = cacheConfigBox.get('cacheTime_$category') as int?;
//       if (cacheTime == null) return false;

//       final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
//       return DateTime.now().difference(cacheDate) < maxCacheAge;
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Future<List<ArticleModel>> getBookmarkedArticles() async {
//     try {
//       return articlesBox.values
//           .where((article) => article.isBookmarked)
//           .toList();
//     } catch (e) {
//       throw CacheException('Failed to retrieve bookmarked articles');
//     }
//   }

//   @override
//   Future<void> toggleBookmark(ArticleModel article) async {
//     try {
//       final updatedArticle =
//           article.copyWith(isBookmarked: !article.isBookmarked);
//       await articlesBox.put(article.id, updatedArticle);
//     } catch (e) {
//       throw CacheException(
//           'Failed to toggle bookmark for article with id: ${article.id}');
//     }
//   }
// }
