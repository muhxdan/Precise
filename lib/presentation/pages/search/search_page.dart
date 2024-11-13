import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/core/utils/assets.dart';
import 'package:precise/presentation/blocs/search/search_bloc.dart';
import 'package:precise/presentation/widgets/app_bar_back_button.dart';
import 'package:precise/presentation/widgets/article_card.dart';
import 'package:precise/presentation/widgets/empty_container.dart';
import 'package:precise/presentation/widgets/loading_animation.dart';
import 'package:precise/presentation/widgets/svg_icon_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debouncer.run(
      () {
        final query = _searchController.text.trim();
        if (query.isEmpty) {
          // Emit initial state when search field is empty
          context.read<SearchBloc>().add(ClearSearch());
        } else {
          context.read<SearchBloc>().add(SearchArticles(query));
        }
      },
    );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(ClearSearch());
  }

  @override
  void deactivate() {
    context.read<SearchBloc>().add(ClearSearch());
    super.deactivate();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
              child: Row(
                children: [
                  const AppBarBackButton(),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: UnconstrainedBox(
                          child: SvgIconButton(
                            assets: AssetVectors.icClose,
                            onTap: _clearSearch,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state.isInitial) {
                    return Center(
                      child: Text(
                        'Enter a keyword to search.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  if (state.isLoading) {
                    return const Center(child: LoadingAnimation());
                  }

                  if (state.errorMessage != null) {
                    return Center(child: Text('Error: ${state.errorMessage}'));
                  }

                  if (state.articles.isEmpty) {
                    return const Center(
                      child: EmptyContainer(text: 'No articles found.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.articles.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.articles.length) {
                        return ArticleCard(article: state.articles[index]);
                      } else {
                        context
                            .read<SearchBloc>()
                            .add(LoadMoreArticles(_searchController.text));
                        return const LoadingAnimation();
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
