import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/models/user_session.dart';
import 'package:test_store/core/services/navigator_service.dart';
import 'package:test_store/core/services/secure_storage_service.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_chip.dart';
import 'package:test_store/core/widgets/aisle_state_block.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/presentator/bloc/discover_bloc.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/category_strip.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/deals_strip.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/discover_header_delegate.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/greeting_row.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/hero_carousel.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/list_footer.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/product_grid_sliver.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/search_field.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/section_header.dart';
import 'package:test_store/screens/product_detail_screen/presentator/view/product_detail_screen.dart';
import 'package:test_store/screens/route_screen/presentator/bloc/route_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? _searchDebounce;
  UserSession? _session;

  @override
  void initState() {
    super.initState();
    context.read<DiscoverBloc>().add(DiscoverStarted());
    _scrollController.addListener(_onScroll);
    _loadSession();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    final session = await SecureStorageService().readUserSession();
    if (mounted) setState(() => _session = session);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter > 800) return;
    final state = context.read<DiscoverBloc>().state;
    if (state.status == StatusIndicator.active &&
        state.pageStatus == StatusIndicator.idle &&
        !state.hasReachedEnd) {
      context.read<DiscoverBloc>().add(DiscoverNextPageRequested());
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
      () => context.read<DiscoverBloc>().add(DiscoverSearchChanged(query)),
    );
  }

  void _onSearchSubmitted(String query) {
    _searchDebounce?.cancel();
    context.read<DiscoverBloc>().add(DiscoverSearchChanged(query));
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    context.read<DiscoverBloc>().add(DiscoverSearchChanged(''));
  }

  void _selectCategory(String? slug) {
    _searchDebounce?.cancel();
    _searchController.clear();
    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    context.read<DiscoverBloc>().add(DiscoverCategorySelected(slug));
  }

  Future<void> _onRefresh() {
    HapticFeedback.selectionClick();
    final completer = Completer<void>();
    context.read<DiscoverBloc>().add(DiscoverRefreshed(completer));
    return completer.future;
  }

  void _openProduct(ProductModel product, String heroTag) {
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    NavigatorService().push(
      ProductDetailScreen(product: product, heroTag: heroTag),
    );
  }

  void _signOut() {
    context.read<RouteBloc>().add(RouteSignedOut());
  }

  String _gridTitle(DiscoverState state) {
    if (state.query.isNotEmpty) return 'Results for "${state.query}"';
    final slug = state.selectedCategory;
    if (slug == null) return 'All products';
    for (final category in state.categories) {
      if (category.slug == slug) return category.name;
    }
    return 'Products';
  }

  List<Widget> _gridSlivers(DiscoverState state) {
    final isLoading =
        state.status == StatusIndicator.loading ||
        state.status == StatusIndicator.idle;

    if (state.status == StatusIndicator.failed) {
      return [
        _stateBlock(
          AisleStateBlock(
            icon: Icons.cloud_off_rounded,
            title: "Couldn't load products",
            message:
                state.errorMessage ?? 'Check your connection and try again.',
            actionLabel: 'Try again',
            onAction: () => context.read<DiscoverBloc>().add(DiscoverRetried()),
          ),
        ),
      ];
    }

    if (!isLoading && state.products.isEmpty) {
      return [
        _stateBlock(
          state.query.isNotEmpty
              ? AisleStateBlock(
                  icon: Icons.search_off_rounded,
                  title: 'No matches for "${state.query}"',
                  message: 'Try a different word or browse a category.',
                  actionLabel: 'Clear search',
                  onAction: _clearSearch,
                )
              : AisleStateBlock(
                  icon: Icons.shopping_bag_outlined,
                  title: 'No products yet',
                  message:
                      'New arrivals will show up here. Pull down to check again.',
                  actionLabel: 'Refresh',
                  onAction: () => _refreshKey.currentState?.show(),
                ),
        ),
      ];
    }

    return [
      ProductGridSliver(
        products: state.products,
        isLoading: isLoading,
        onProductTap: (product) => _openProduct(product, 'grid-${product.id}'),
      ),
      if (!isLoading)
        SliverToBoxAdapter(
          child: ListFooter(
            pageStatus: state.pageStatus,
            hasReachedEnd: state.hasReachedEnd,
            total: state.total,
            onRetry: () => context.read<DiscoverBloc>().add(
              DiscoverNextPageRequested(isRetry: true),
            ),
          ),
        ),
    ];
  }

  Widget _stateBlock(Widget child) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kGutter, 32, kGutter, 32),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final padding = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: BlocConsumer<DiscoverBloc, DiscoverState>(
          listenWhen: (previous, current) =>
              previous.noticeId != current.noticeId,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.noticeMessage ?? '')),
              );
          },
          builder: (context, state) {
            final header = DiscoverHeaderDelegate(
              topPadding: padding.top,
              greeting: GreetingRow(
                greeting: Utils.greeting(DateTime.now()),
                name: _session?.firstName ?? '',
                imageUrl: _session?.image ?? '',
                onSignOut: _signOut,
              ),
              search: SearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                onClear: _clearSearch,
              ),
              hero: HeroCarousel(onSlideTap: _selectCategory),
            );

            return RefreshIndicator(
              key: _refreshKey,
              onRefresh: _onRefresh,
              edgeOffset: header.maxExtent,
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPersistentHeader(pinned: true, delegate: header),
                  const SliverToBoxAdapter(child: SizedBox(height: 28)),
                  const SliverToBoxAdapter(
                    child: SectionHeader(title: 'Shop by category'),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: CategoryStrip(
                      categories: state.categories,
                      status: state.categoriesStatus,
                      selectedSlug: state.query.isEmpty
                          ? state.selectedCategory
                          : '',
                      onSelected: _selectCategory,
                      onRetry: () =>
                          context.read<DiscoverBloc>().add(DiscoverRetried()),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Deals of the day',
                      trailing: state.deals.isEmpty
                          ? null
                          : AisleChip(
                              label:
                                  'Up to ${state.deals.first.discountPercentage.round()}% off',
                              foreground: AppColors.plum,
                              background: AppColors.plumSoft,
                            ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: DealsStrip(
                      deals: state.deals,
                      status: state.dealsStatus,
                      onDealTap: (product) =>
                          _openProduct(product, 'deal-${product.id}'),
                      onRetry: () =>
                          context.read<DiscoverBloc>().add(DiscoverRetried()),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: _gridTitle(state),
                      trailing: state.status == StatusIndicator.active
                          ? Text(
                              '${state.total}',
                              style: textTheme.bodySmall!.copyWith(
                                color: AppColors.inkTertiary,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ..._gridSlivers(state),
                  SliverToBoxAdapter(
                    child: SizedBox(height: padding.bottom + 16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
