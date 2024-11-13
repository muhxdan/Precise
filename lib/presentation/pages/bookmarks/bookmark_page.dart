import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/routes/app_routes.dart';
import 'package:precise/presentation/blocs/bookmark/bookmark_bloc.dart';
import 'package:precise/presentation/widgets/article_card.dart';
import 'package:precise/presentation/widgets/empty_container.dart';
import 'package:precise/presentation/widgets/loading_animation.dart';

// class BookmarksPage extends StatelessWidget {
//   const BookmarksPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bookmarks'),
//       ),
//       body: BlocBuilder<BookmarksBloc, BookmarksState>(
//         builder: (context, state) {
//           if (state is BookmarksInitial || state is BookmarksLoading) {
//             return const Center(child: LoadingAnimation());
//           } else if (state is BookmarksError) {
//             return Center(child: Text(state.message));
//           } else if (state is BookmarksLoaded) {
//             if (state.bookmarkedArticles.isEmpty) {
//               return const EmptyContainer(text: 'No bookmarked articles yet');
//             }
//             return ListView.builder(
//               itemCount: state.bookmarkedArticles.length,
//               itemBuilder: (context, index) {
//                 final article = state.bookmarkedArticles[index];
//                 return GestureDetector(
//                   onTap: () => context.push(AppRoutes.detail, extra: article),
//                   child: ArticleCard(article: article),
//                 );
//               },
//             );
//           }

//           return Center(
//             child: Text(
//               'Something went wrong',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: LoadingAnimation());
          }

          if (state.hasError) {
            return Center(child: Text(state.error!));
          }

          if (state.isEmpty) {
            return const EmptyContainer(text: 'No bookmarked articles yet');
          }

          return ListView.builder(
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              final article = state.articles[index];
              return GestureDetector(
                onTap: () => context.push(AppRoutes.detail, extra: article),
                child: ArticleCard(article: article),
              );
            },
          );
        },
      ),
    );
  }
}
