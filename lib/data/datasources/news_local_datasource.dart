// import 'package:hive/hive.dart';
// import 'package:precise/data/models/article_model.dart';

// abstract class NewsLocalDataSource {
//   Future<void> cacheArticles(List<ArticleModel> articles);
//   Future<List<ArticleModel>> getCachedArticles();
//   Future<DateTime?> getLastCacheTime(); // Tambahkan fungsi ini
// }

// class NewsLocalDataSourceImpl implements NewsLocalDataSource {
//   final Box<ArticleModel> articleBox;
//   final Box<DateTime> cacheTimeBox;

//   NewsLocalDataSourceImpl({
//     required this.articleBox,
//     required this.cacheTimeBox,
//   });

//   @override
//   Future<void> cacheArticles(List<ArticleModel> articles) async {
//     await articleBox.clear();
//     await articleBox.addAll(articles);

//     // Simpan waktu penyimpanan terakhir sebagai timestamp
//     await cacheTimeBox.put('cacheTime', DateTime.now());
//   }

//   @override
//   Future<List<ArticleModel>> getCachedArticles() async {
//     return articleBox.values.toList();
//   }

//   @override
//   Future<DateTime?> getLastCacheTime() async {
//     return cacheTimeBox.get('cacheTime');
//   }
// }
