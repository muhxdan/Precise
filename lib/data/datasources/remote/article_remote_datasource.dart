import 'package:precise/core/errors/exceptions.dart';
import 'package:precise/core/network/api_client.dart';
import 'package:precise/core/network/api_constants.dart';
import 'package:precise/data/models/article_model.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getArticles({String? category, int page});
  Future<List<ArticleModel>> searchArticles(String keyword, int page);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final ApiClient client;

  ArticleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArticleModel>> getArticles({
    String? category,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'api-key': ApiConstants.apiKey,
        'show-fields': 'thumbnail,trailText',
        'page-size': '10',
        'page': page.toString(),
        if (category != null && category != 'all') 'section': category,
      };

      final response =
          await client.get('/search', queryParameters: queryParams);
      final results = response.data['response']['results'] as List;
      return results.map((article) => ArticleModel.fromJson(article)).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles(String keyword, int page) async {
    try {
      final queryParams = {
        'api-key': ApiConstants.apiKey,
        'show-fields': 'thumbnail,trailText',
        'page-size': '10',
        'page': page.toString(),
        'q': keyword,
      };

      final response =
          await client.get('/search', queryParameters: queryParams);
      final results = response.data['response']['results'] as List;
      return results.map((article) => ArticleModel.fromJson(article)).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }
}


// abstract class ArticleRemoteDataSource {
//   /// Fetches a list of articles with pagination, optionally filtered by category.
//   Future<List<ArticleModel>> getArticles(
//       {String? category, int page = 1, int pageSize = 20});

//   /// Searches for articles based on a search query with pagination.
//   Future<List<ArticleModel>> searchArticles(String keyword,
//       {int page = 1, int pageSize = 20});
// }

// class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
//   final ApiClient apiClient;

//   ArticleRemoteDataSourceImpl({required this.apiClient});

//   @override
//   Future<List<ArticleModel>> getArticles(
//       {String? category, int page = 1, int pageSize = 20}) async {
//     try {
//       final response = await apiClient.get(
//         '/search',
//         queryParameters: {
//           if (category != "all") 'section': category,
//           'show-fields': 'thumbnail',
//           'page': page,
//           'page-size': pageSize,
//         },
//       );

//       final data = response.data['response']['results'] as List;
//       return data.map((json) => ArticleModel.fromJson(json)).toList();
//     } catch (e) {
//       throw ServerException('Failed to fetch articles with pagination');
//     }
//   }

//   @override
//   Future<List<ArticleModel>> searchArticles(String keyword,
//       {int page = 1, int pageSize = 20}) async {
//     try {
//       final response = await apiClient.get(
//         '/search',
//         queryParameters: {
//           'q': keyword,
//           'show-fields': 'trailText,thumbnail,body',
//           'page': page,
//           'page-size': pageSize,
//         },
//       );

//       final data = response.data['response']['results'] as List;
//       return data.map((json) => ArticleModel.fromJson(json)).toList();
//     } catch (e) {
//       throw ServerException('Failed to search articles with pagination');
//     }
//   }
// }
// abstract class ArticleRemoteDataSource {
//   Future<List<ArticleModel>> getArticles({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   });
// }

// class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
//   final ApiClient client;

//   ArticleRemoteDataSourceImpl(this.client);

//   @override
//   Future<List<ArticleModel>> getArticles({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   }) async {
//     final response = await client.get(
//       '/search',
//       queryParameters: {
//         'page': page,
//         'page-size': pageSize,
//         if (category != null && category != 'All') 'section': category,
//         if (query != null) 'q': query,
//         'api-key': AppConstants.apiKey,
//       },
//     );

//     final articlesData = response.data['response']['results'] as List;
//     return articlesData.map((json) => ArticleModel.fromJson(json)).toList();
//   }
// }
