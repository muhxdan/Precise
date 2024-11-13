import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/exceptions.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/network/network_info.dart';
import 'package:precise/data/datasources/local/article_local_datasource.dart';
import 'package:precise/data/datasources/remote/article_remote_datasource.dart';
import 'package:precise/data/models/article_model.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Future<List<Article>> _processArticles(List<ArticleModel> articles) async {
    // Get all bookmarked article ids
    final bookmarkedArticles = await localDataSource.getBookmarkedArticles();
    final bookmarkedIds = bookmarkedArticles.map((e) => e.id).toSet();

    // Update articles with bookmark status from bookmarkBox
    return articles.map((article) {
      final isBookmarked = bookmarkedIds.contains(article.id);
      // Selalu gunakan status bookmark dari bookmarkBox
      return article.copyWith(isBookmarked: isBookmarked).toEntity();
    }).toList();
  }

  @override
  Future<Either<Failure, List<Article>>> getArticles({
    String? category,
    bool forceRefresh = false,
    int page = 1,
    bool shouldCache = true,
  }) async {
    try {
      if (page == 1 && shouldCache) {
        final isCacheValid = await localDataSource.isCacheValid(category);

        if (!forceRefresh && isCacheValid) {
          final cachedArticles =
              await localDataSource.getCachedArticles(category);
          if (cachedArticles != null && cachedArticles.isNotEmpty) {
            // Pastikan status bookmark selalu diambil dari bookmarkBox
            return Right(await _processArticles(cachedArticles));
          }
        }
      }

      if (await networkInfo.isConnected) {
        final remoteArticles = await remoteDataSource.getArticles(
          category: category,
          page: page,
        );

        if (page == 1 && shouldCache) {
          // Simpan artikel tanpa mengubah status bookmark yang ada
          await localDataSource.cacheArticles(remoteArticles, category);
        }

        // Proses artikel dengan status bookmark yang benar
        return Right(await _processArticles(remoteArticles));
      } else {
        if (page == 1) {
          final cachedArticles =
              await localDataSource.getCachedArticles(category);
          if (cachedArticles != null && cachedArticles.isNotEmpty) {
            return Right(await _processArticles(cachedArticles));
          }
        }
        return const Left(NetworkFailure('No internet connection'));
      }
    } on ServerException {
      return const Left(ServerFailure());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(
      String keyword, int page) async {
    if (await networkInfo.isConnected) {
      try {
        // Ambil hasil pencarian dari remote
        final remoteArticles =
            await remoteDataSource.searchArticles(keyword, page);

        // Proses artikel dengan status bookmark yang benar
        final processedArticles = await _processArticles(remoteArticles);

        return Right(processedArticles);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getBookmarkedArticles() async {
    try {
      final localArticles = await localDataSource.getBookmarkedArticles();
      return Right(localArticles.map((model) => model.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Article>> toggleBookmark(Article article) async {
    try {
      final articleModel = ArticleModel.fromEntity(article);
      final updatedModel = await localDataSource.toggleBookmark(articleModel);
      return Right(updatedModel.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}

// class ArticleRepositoryImpl implements ArticleRepository {
//   final ArticleRemoteDataSource remoteDataSource;
//   final ArticleLocalDataSource localDataSource;
//   final Duration maxCacheAge;

//   ArticleRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     this.maxCacheAge = const Duration(hours: 1),
//   });

//   @override
//   Future<Either<Failure, List<Article>>> getArticles({
//     String? category,
//     bool forceRefresh = false,
//     int page = 1,
//     int pageSize = 10,
//   }) async {
//     final categoryKey = category ?? 'all';
//     debugPrint("check: forceRefresh: $forceRefresh, page: $page");

//     // Untuk page pertama, cek cache terlebih dahulu
//     if (page == 1 && !forceRefresh) {
//       final isCacheValid =
//           await localDataSource.isCacheValid(categoryKey, maxCacheAge);
//       debugPrint("check: isCacheValid: $isCacheValid");

//       if (isCacheValid) {
//         try {
//           final cachedArticles =
//               await localDataSource.getCachedArticles(categoryKey);
//           if (cachedArticles.isNotEmpty) {
//             return Right(
//                 cachedArticles.map((model) => model.toEntity()).toList());
//           }
//         } on CacheException {
//           // Jika gagal mengambil cache, lanjut ke remote
//           debugPrint("Cache exception occurred, falling back to remote");
//         }
//       }
//     }

//     // Jika page > 1 atau cache tidak valid/kosong, ambil dari remote
//     try {
//       final remoteArticles = await remoteDataSource.getArticles(
//         category: category,
//         page: page,
//         pageSize: pageSize,
//       );

//       // Hanya cache data jika ini adalah page pertama
//       if (page == 1) {
//         await localDataSource.cacheArticles(categoryKey, remoteArticles);
//       }

//       return Right(remoteArticles.map((model) => model.toEntity()).toList());
//     } on ServerException {
//       // Jika gagal mengambil dari remote dan ini page pertama,
//       // coba ambil dari cache sebagai fallback
//       if (page == 1) {
//         try {
//           final cachedArticles =
//               await localDataSource.getCachedArticles(categoryKey);
//           return Right(
//               cachedArticles.map((model) => model.toEntity()).toList());
//         } on CacheException {
//           return const Left(CacheFailure(
//               'Failed to retrieve articles. Please check your internet connection.'));
//         }
//       }
//       return const Left(ServerFailure('Failed to fetch articles from server.'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Article>>> searchArticles(String keyword) async {
//     try {
//       final remoteArticles = await remoteDataSource.searchArticles(keyword);
//       return Right(remoteArticles.map((model) => model.toEntity()).toList());
//     } on ServerException {
//       return Left(
//           ServerFailure('Failed to search articles with keyword: $keyword.'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Article>>> getBookmarkedArticles() async {
//     try {
//       final bookmarkedArticles = await localDataSource.getBookmarkedArticles();
//       return Right(
//           bookmarkedArticles.map((model) => model.toEntity()).toList());
//     } on CacheException {
//       return const Left(
//           CacheFailure('Failed to retrieve bookmarked articles.'));
//     }
//   }

//   @override
//   Future<Either<Failure, Article>> toggleBookmark(Article article) async {
//     try {
//       final articleModel = ArticleModel.fromEntity(article);
//       await localDataSource.toggleBookmark(articleModel);
//       final updatedModel =
//           articleModel.copyWith(isBookmarked: !article.isBookmarked);
//       return Right(updatedModel.toEntity());
//     } on CacheException {
//       return Left(CacheFailure(
//           'Failed to toggle bookmark for article with id: ${article.id}.'));
//     }
//   }
// }

// data/repositories/article_repository_impl.dart
// class ArticleRepositoryImpl implements ArticleRepository {
//   final ArticleRemoteDataSource remoteDataSource;
//   final ArticleLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   ArticleRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<List<Article>> getArticles({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   }) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final articles = await remoteDataSource.getArticles(
//           page: page,
//           pageSize: pageSize,
//           category: category,
//           query: query,
//         );
//         if (page == 1) {
//           await localDataSource.cacheArticles(articles);
//         }
//         return articles.map((model) => model.toEntity()).toList();
//       } catch (e) {
//         if (page == 1) {
//           return (await localDataSource.getCachedArticles())
//               .map((model) => model.toEntity())
//               .toList();
//         }
//         rethrow;
//       }
//     } else {
//       return (await localDataSource.getCachedArticles())
//           .map((model) => model.toEntity())
//           .toList();
//     }
//   }

//   @override
//   Future<List<Article>> getBookmarkedArticles() async {
//     final articles = await localDataSource.getBookmarkedArticles();
//     return articles.map((model) => model.toEntity()).toList();
//   }

//   @override
//   Future<void> toggleBookmark(Article article) async {
//     final articleModel = ArticleModel.fromEntity(article);
//     await localDataSource.toggleBookmark(articleModel);
//   }
// }

// class ArticleRepositoryImpl implements ArticleRepository {
//   final ArticleRemoteDataSource remoteDataSource;
//   final ArticleLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   ArticleRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, List<Article>>> getArticles({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   }) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final articleModels = await remoteDataSource.getArticles(
//           page: page,
//           pageSize: pageSize,
//           category: category,
//           query: query,
//         );

//         if (page == 1) {
//           await localDataSource.cacheArticles(articleModels);
//         }

//         final articles =
//             articleModels.map((model) => model.toEntity()).toList();
//         return Right(articles);
//       } catch (e) {
//         return Left(ServerFailure(e.toString()));
//       }
//     } else {
//       try {
//         final localArticleModels = await localDataSource.getCachedArticles();
//         final articles =
//             localArticleModels.map((model) => model.toEntity()).toList();
//         return Right(articles);
//       } catch (e) {
//         return const Left(
//             CacheFailure('No internet connection and no cached data'));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, List<Article>>> getBookmarkedArticles() async {
//     try {
//       final articleModels = await localDataSource.getBookmarkedArticles();
//       final articles = articleModels.map((model) => model.toEntity()).toList();
//       return Right(articles);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> toggleBookmark(Article article) async {
//     try {
//       final articleModel = ArticleModel.fromEntity(article);
//       await localDataSource.toggleBookmark(articleModel);
//       return const Right(true);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }
// }
