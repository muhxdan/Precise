import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:precise/domain/entities/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article.imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.error)),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                article.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                '${DateFormat.yMMMd().format(article.publishedAt)}   |   ${article.category}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
