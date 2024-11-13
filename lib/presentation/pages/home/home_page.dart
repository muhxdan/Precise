import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/routes/app_routes.dart';
import 'package:precise/core/utils/assets.dart';
import 'package:precise/core/utils/constants.dart';
import 'package:precise/presentation/blocs/article/article_bloc.dart';
import 'package:precise/presentation/pages/home/widgets/article_list.dart';
import 'package:precise/presentation/pages/home/widgets/categories_list.dart';
import 'package:precise/presentation/widgets/empty_container.dart';
import 'package:precise/presentation/widgets/loading_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  String _selectedCategory = Constants.categories.first;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ArticlesBloc>().add(const GetArticlesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ArticlesBloc>().add(
            GetArticlesEvent(
              category: _selectedCategory == 'all' ? null : _selectedCategory,
              loadMore: true,
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.search),
            child: SvgPicture.asset(
              AssetVectors.icSearch,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: Column(
        children: [
          CategoryList(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() => _selectedCategory = category);
              context.read<ArticlesBloc>().add(
                    GetArticlesEvent(
                      category: category == 'all' ? null : category,
                    ),
                  );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ArticlesBloc, ArticlesState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: LoadingAnimation());
                }
                if (state.hasError) {
                  return Center(child: Text(state.error!));
                }

                if (state.isEmpty) {
                  return const EmptyContainer(text: 'No articles yet');
                }

                return ArticleList(
                  scrollController: _scrollController,
                  articles: state.articles,
                  isLoadingMore: state.isLoadingMore,
                  onRefresh: () {
                    context.read<ArticlesBloc>().add(
                          GetArticlesEvent(
                            category: _selectedCategory == 'all'
                                ? null
                                : _selectedCategory,
                            forceRefresh: true,
                          ),
                        );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: const InputDecoration(
          //       hintText: 'Search articles...',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(),
          //     ),
          //     onChanged: _onSearchChanged,
          //   ),
          // ),

  // void _onSearchChanged(String query) {
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     if (query.isNotEmpty) {
  //       context.read<ArticlesBloc>().add(SearchArticlesEvent(query));
  //     } else {
  //       context
  //           .read<ArticlesBloc>()
  //           .add(GetArticlesEvent(category: _selectedCategory));
  //     }
  //   });
  // }