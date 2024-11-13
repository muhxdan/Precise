import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/routes/app_routes.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/presentation/widgets/article_card.dart';
import 'package:precise/presentation/widgets/loading_animation.dart';

class ArticleList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Article> articles;
  final bool isLoadingMore;
  final VoidCallback onRefresh;

  const ArticleList({
    super.key,
    required this.scrollController,
    required this.articles,
    required this.isLoadingMore,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(seconds: 2));
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: articles.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= articles.length) {
            return const Center(child: LoadingAnimation());
          }
          final article = articles[index];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.detail, extra: article),
            child: ArticleCard(article: article),
          );
        },
      ),
    );
  }
}
