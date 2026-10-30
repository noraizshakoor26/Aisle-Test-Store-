import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_store/core/api/result.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/discover_screen/data/models/category_model.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';
import 'package:test_store/screens/discover_screen/domain/usecases/get_categories_usecase.dart';
import 'package:test_store/screens/discover_screen/domain/usecases/get_deals_usecase.dart';
import 'package:test_store/screens/discover_screen/domain/usecases/get_products_by_category_usecase.dart';
import 'package:test_store/screens/discover_screen/domain/usecases/get_products_usecase.dart';
import 'package:test_store/screens/discover_screen/domain/usecases/search_products_usecase.dart';

part 'discover_event.dart';
part 'discover_state.dart';

const int _dealsLimit = 8;

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetProductsUseCase _getProducts;
  final SearchProductsUseCase _searchProducts;
  final GetProductsByCategoryUseCase _getProductsByCategory;
  final GetCategoriesUseCase _getCategories;
  final GetDealsUseCase _getDeals;

  // Bumped on every grid reset, so a slow response for an older search or
  // category can never overwrite the grid the user is now looking at.
  int _gridRequestId = 0;

  DiscoverBloc({required DiscoverRepository repository})
    : _getProducts = GetProductsUseCase(repository),
      _searchProducts = SearchProductsUseCase(repository),
      _getProductsByCategory = GetProductsByCategoryUseCase(repository),
      _getCategories = GetCategoriesUseCase(repository),
      _getDeals = GetDealsUseCase(repository),
      super(const DiscoverState()) {
    on<DiscoverStarted>(_onStarted);
    on<DiscoverRefreshed>(_onRefreshed);
    on<DiscoverRetried>(_onRetried);
    on<DiscoverNextPageRequested>(_onNextPageRequested);
    on<DiscoverSearchChanged>(_onSearchChanged);
    on<DiscoverCategorySelected>(_onCategorySelected);
  }

  Future<Result<ProductsResponseModel>> _fetchPage({
    required String query,
    required String? category,
    required int skip,
  }) {
    if (query.isNotEmpty) {
      return _searchProducts.execute(
        query: query,
        limit: kPageSize,
        skip: skip,
      );
    }
    if (category != null) {
      return _getProductsByCategory.execute(
        slug: category,
        limit: kPageSize,
        skip: skip,
      );
    }
    return _getProducts.execute(limit: kPageSize, skip: skip);
  }

  Future<void> _loadGrid(
    Emitter<DiscoverState> emit, {
    required String query,
    required String? category,
  }) async {
    final requestId = ++_gridRequestId;
    emit(
      state.copyWith(
        status: StatusIndicator.loading,
        products: const [],
        total: 0,
        pageStatus: StatusIndicator.idle,
        query: query,
        selectedCategory: category,
        clearCategory: category == null,
        clearError: true,
      ),
    );

    final result = await _fetchPage(query: query, category: category, skip: 0);
    if (requestId != _gridRequestId) return;

    result.fold(
      onFailure: (failure) => emit(
        state.copyWith(
          status: StatusIndicator.failed,
          errorMessage: failure.message,
        ),
      ),
      onSuccess: (page) => emit(
        state.copyWith(
          status: StatusIndicator.active,
          products: page.products,
          total: page.total,
        ),
      ),
    );
  }

  Future<void> _loadCategories(Emitter<DiscoverState> emit) async {
    emit(state.copyWith(categoriesStatus: StatusIndicator.loading));
    final result = await _getCategories.execute();
    result.fold(
      onFailure: (_) =>
          emit(state.copyWith(categoriesStatus: StatusIndicator.failed)),
      onSuccess: (categories) => emit(
        state.copyWith(
          categories: categories,
          categoriesStatus: StatusIndicator.active,
        ),
      ),
    );
  }

  Future<void> _loadDeals(Emitter<DiscoverState> emit) async {
    emit(state.copyWith(dealsStatus: StatusIndicator.loading));
    final result = await _getDeals.execute(limit: _dealsLimit);
    result.fold(
      onFailure: (_) =>
          emit(state.copyWith(dealsStatus: StatusIndicator.failed)),
      onSuccess: (deals) => emit(
        state.copyWith(deals: deals, dealsStatus: StatusIndicator.active),
      ),
    );
  }

  Future<void> _onStarted(
    DiscoverStarted event,
    Emitter<DiscoverState> emit,
  ) async {
    await Future.wait([
      _loadCategories(emit),
      _loadDeals(emit),
      _loadGrid(emit, query: '', category: null),
    ]);
  }

  Future<void> _onRefreshed(
    DiscoverRefreshed event,
    Emitter<DiscoverState> emit,
  ) async {
    final requestId = ++_gridRequestId;
    final query = state.query;
    final category = state.selectedCategory;

    final results = await Future.wait([
      _fetchPage(query: query, category: category, skip: 0),
      _getCategories.execute(),
      _getDeals.execute(limit: _dealsLimit),
    ]);
    final pageResult = results[0] as Result<ProductsResponseModel>;
    final categoriesResult = results[1] as Result<List<CategoryModel>>;
    final dealsResult = results[2] as Result<List<ProductModel>>;

    if (categoriesResult.isSuccess) {
      emit(
        state.copyWith(
          categories: categoriesResult.data,
          categoriesStatus: StatusIndicator.active,
        ),
      );
    }
    if (dealsResult.isSuccess) {
      emit(
        state.copyWith(
          deals: dealsResult.data,
          dealsStatus: StatusIndicator.active,
        ),
      );
    }

    if (requestId == _gridRequestId) {
      pageResult.fold(
        onFailure: (failure) {
          if (state.products.isEmpty) {
            emit(
              state.copyWith(
                status: StatusIndicator.failed,
                errorMessage: failure.message,
              ),
            );
          } else {
            emit(
              state.copyWith(
                noticeMessage: failure.message,
                noticeId: state.noticeId + 1,
                pageStatus: state.pageStatus == StatusIndicator.loadingMore
                    ? StatusIndicator.idle
                    : null,
              ),
            );
          }
        },
        onSuccess: (page) => emit(
          state.copyWith(
            status: StatusIndicator.active,
            products: page.products,
            total: page.total,
            pageStatus: StatusIndicator.idle,
            clearError: true,
          ),
        ),
      );
    }

    event.completer.complete();
  }

  Future<void> _onRetried(
    DiscoverRetried event,
    Emitter<DiscoverState> emit,
  ) async {
    await Future.wait([
      if (state.categoriesStatus == StatusIndicator.failed)
        _loadCategories(emit),
      if (state.dealsStatus == StatusIndicator.failed) _loadDeals(emit),
      if (state.status == StatusIndicator.failed)
        _loadGrid(emit, query: state.query, category: state.selectedCategory),
    ]);
  }

  Future<void> _onNextPageRequested(
    DiscoverNextPageRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    final blocked =
        state.status != StatusIndicator.active ||
        state.pageStatus == StatusIndicator.loadingMore ||
        state.hasReachedEnd ||
        (state.pageStatus == StatusIndicator.failed && !event.isRetry);
    if (blocked) return;

    final requestId = _gridRequestId;
    emit(state.copyWith(pageStatus: StatusIndicator.loadingMore));

    final result = await _fetchPage(
      query: state.query,
      category: state.selectedCategory,
      skip: state.products.length,
    );
    if (requestId != _gridRequestId) return;

    result.fold(
      onFailure: (_) =>
          emit(state.copyWith(pageStatus: StatusIndicator.failed)),
      onSuccess: (page) => emit(
        state.copyWith(
          products: [...state.products, ...page.products],
          total: page.total,
          pageStatus: StatusIndicator.idle,
        ),
      ),
    );
  }

  Future<void> _onSearchChanged(
    DiscoverSearchChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    final query = event.query.trim();
    if (query == state.query && state.status != StatusIndicator.failed) return;
    await _loadGrid(emit, query: query, category: null);
  }

  Future<void> _onCategorySelected(
    DiscoverCategorySelected event,
    Emitter<DiscoverState> emit,
  ) async {
    final unchanged =
        event.slug == state.selectedCategory && state.query.isEmpty;
    if (unchanged && state.status != StatusIndicator.failed) return;
    await _loadGrid(emit, query: '', category: event.slug);
  }
}
