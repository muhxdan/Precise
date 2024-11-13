import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/core/theme/app_colors.dart';
import 'package:precise/core/utils/assets.dart';
import 'package:precise/core/utils/constants.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/presentation/blocs/article/article_bloc.dart';
import 'package:precise/presentation/blocs/bookmark/bookmark_bloc.dart';
import 'package:precise/presentation/widgets/app_bar_back_button.dart';
import 'package:precise/presentation/widgets/loading_animation.dart';
import 'package:precise/presentation/widgets/svg_icon_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final Article article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late WebViewController _webViewController;
  late bool _isLoading;
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isBookmarked = widget.article.isBookmarked;
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(_buildNavigationDelegate())
      ..loadRequest(Uri.parse(widget.article.url));
  }

  NavigationDelegate _buildNavigationDelegate() {
    return NavigationDelegate(
      onPageStarted: (_) => _setLoading(true),
      onPageFinished: (_) => _setLoading(false),
    );
  }

  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  void _handleReload() {
    _webViewController.reload();
  }

  void _handleActionSnackbar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _handleBookmarkToggle() {
    context.read<BookmarksBloc>().add(ToggleBookmarkEvent(widget.article));
  }

  void _handleShare() async {
    await Share.share(widget.article.url);
  }

  void _showBookmarkSnackBar(bool wasBookmarked) {
    final message = wasBookmarked
        ? Constants.removedFromBookmarks
        : Constants.addedToBookmarks;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.darkOnBackground),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: _handleActionSnackbar,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookmarksBloc, BookmarksState>(
      listenWhen: (previous, current) =>
          previous.lastToggledArticle != current.lastToggledArticle &&
          current.lastToggledArticle != null,
      listener: (context, state) {
        final toggledArticle = state.lastToggledArticle!;
        if (toggledArticle.id == widget.article.id) {
          final wasBookmarked = _isBookmarked;
          setState(() => _isBookmarked = toggledArticle.isBookmarked);

          context
              .read<ArticlesBloc>()
              .add(UpdateArticleBookmarkEvent(toggledArticle));

          _showBookmarkSnackBar(wasBookmarked);
        }
      },
      // listener: (context, state) {
      //   if (state is BookmarkToggled) {
      //     final wasBookmarked = _isBookmarked;
      //     setState(() => _isBookmarked = state.article.isBookmarked);

      //     context
      //         .read<ArticlesBloc>()
      //         .add(UpdateArticleBookmarkEvent(state.article));

      //     _showBookmarkSnackBar(wasBookmarked);
      //   }
      // },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const AppBarBackButton(),
      actions: [
        SvgIconButton(
          assets: AssetVectors.icReload,
          onTap: _handleReload,
        ),
        const SizedBox(width: 20),
        SvgIconButton(
          assets: _isBookmarked
              ? AssetVectors.icBookmarkActiveDark
              : AssetVectors.icBookmark,
          color: _isBookmarked
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onSurface,
          onTap: _handleBookmarkToggle,
        ),
        const SizedBox(width: 20),
        SvgIconButton(
          assets: AssetVectors.icShare,
          onTap: _handleShare,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        WebViewWidget(controller: _webViewController),
        if (_isLoading)
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(
              child: LoadingAnimation(),
            ),
          ),
      ],
    );
  }
}
