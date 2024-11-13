// import 'package:dio/dio.dart';
// import 'package:logger/logger.dart';
// import 'package:precise/core/network/api_constants.dart';
// import 'package:precise/data/models/article_model.dart';

// abstract class NewsRemoteDataSource {
//   Future<List<ArticleModel>> getArticles();
//   Future<List<ArticleModel>> getArticlesByCategory(String categoryId);
// }

// // class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
// //   final Dio dio;
// //   final Logger logger;
// //
// //   NewsRemoteDataSourceImpl({required this.dio, required this.logger});
// //
// //   @override
// //   Future<List<ArticleModel>> getArticles() async {
// //     logger.i("Fetching all articles from API");
// //     final response = await dio.get('/search', queryParameters: {
// //       'api-key': ApiConstants.apiKey,
// //       'show-fields': 'thumbnail',
// //     });
// //
// //     if (response.statusCode == 200) {
// //       final List<dynamic> articlesJson = response.data['response']['results'];
// //       logger.i("Fetched ${articlesJson.length} articles from API");
// //       return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
// //     } else {
// //       logger.e("Failed to fetch all articles: ${response.statusMessage}");
// //       logger.d("Base URL: ${dio.options.baseUrl}");
// //       throw Exception('Failed to load articles');
// //     }
// //   }
// //
// //   @override
// //   Future<List<ArticleModel>> getArticlesByCategory(String categoryId) async {
// //     logger.i("Fetching articles from API for category $categoryId");
// //     final response = await dio.get('/search', queryParameters: {
// //       'api-key': ApiConstants.apiKey,
// //       'section': categoryId,
// //       'show-fields': 'thumbnail',
// //     });
// //
// //     if (response.statusCode == 200) {
// //       final List<dynamic> articlesJson = response.data['response']['results'];
// //       logger.i(
// //           "Fetched ${articlesJson.length} articles from API for category $categoryId");
// //       return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
// //     } else {
// //       logger.e(
// //           "Failed to fetch articles for category $categoryId: ${response.statusMessage}");
// //       throw Exception('Failed to load articles by category');
// //     }
// //   }
// // }
// class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
//   final Dio dio;
//   final Logger logger;

//   NewsRemoteDataSourceImpl({required this.dio, required this.logger});

//   @override
//   Future<List<ArticleModel>> getArticles() async {
//     try {
//       logger.i("Fetching all articles from API");
//       logger.d("Base URL: ${dio.options.baseUrl}");

//       final response = await dio.get('/search', queryParameters: {
//         'api-key': ApiConstants.apiKey,
//         'show-fields': 'thumbnail',
//       });

//       if (response.statusCode == 200) {
//         final List<dynamic> articlesJson = response.data['response']['results'];
//         logger.i("Fetched ${articlesJson.length} articles from API");
//         return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
//       } else {
//         logger.e("Failed to fetch all articles: ${response.statusMessage}");
//         throw DioException(
//           requestOptions: response.requestOptions,
//           message: 'Failed to load articles',
//         );
//       }
//     } on DioException catch (e) {
//       logger.e("DioException occurred: ${e.message}");
//       logger.d("Request URL: ${e.requestOptions.uri}");
//       rethrow;
//     }
//   }

//   @override
//   Future<List<ArticleModel>> getArticlesByCategory(String categoryId) async {
//     try {
//       logger.i("Fetching articles from API for category $categoryId");

//       final response = await dio.get('/search', queryParameters: {
//         'api-key': ApiConstants.apiKey,
//         'section': categoryId,
//         'show-fields': 'thumbnail',
//       });

//       if (response.statusCode == 200) {
//         final List<dynamic> articlesJson = response.data['response']['results'];
//         logger.i("Fetched ${articlesJson.length} articles for category $categoryId");
//         return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
//       } else {
//         logger.e("Failed to fetch articles for category $categoryId: ${response.statusMessage}");
//         throw DioException(
//           requestOptions: response.requestOptions,
//           message: 'Failed to load articles by category',
//         );
//       }
//     } on DioException catch (e) {
//       logger.e("DioException occurred while fetching category $categoryId: ${e.message}");
//       logger.d("Request URL: ${e.requestOptions.uri}");
//       rethrow;
//     }
//   }
// }