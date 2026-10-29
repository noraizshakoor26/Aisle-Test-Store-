part of 'discover_bloc.dart';

class DiscoverState {
  final StatusIndicator status;
  final List<ProductModel> products;
  final int total;
  final StatusIndicator pageStatus;
  final String query;
  final String? selectedCategory;
  final List<CategoryModel> categories;
  final StatusIndicator categoriesStatus;
  final List<ProductModel> deals;
  final StatusIndicator dealsStatus;
  final String? errorMessage;
  final String? noticeMessage;
  final int noticeId;

  const DiscoverState({
    this.status = StatusIndicator.idle,
    this.products = const [],
    this.total = 0,
    this.pageStatus = StatusIndicator.idle,
    this.query = '',
    this.selectedCategory,
    this.categories = const [],
    this.categoriesStatus = StatusIndicator.idle,
    this.deals = const [],
    this.dealsStatus = StatusIndicator.idle,
    this.errorMessage,
    this.noticeMessage,
    this.noticeId = 0,
  });

  bool get hasReachedEnd => products.length >= total;

  DiscoverState copyWith({
    StatusIndicator? status,
    List<ProductModel>? products,
    int? total,
    StatusIndicator? pageStatus,
    String? query,
    String? selectedCategory,
    bool clearCategory = false,
    List<CategoryModel>? categories,
    StatusIndicator? categoriesStatus,
    List<ProductModel>? deals,
    StatusIndicator? dealsStatus,
    String? errorMessage,
    bool clearError = false,
    String? noticeMessage,
    int? noticeId,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      products: products ?? this.products,
      total: total ?? this.total,
      pageStatus: pageStatus ?? this.pageStatus,
      query: query ?? this.query,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      deals: deals ?? this.deals,
      dealsStatus: dealsStatus ?? this.dealsStatus,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      noticeMessage: noticeMessage ?? this.noticeMessage,
      noticeId: noticeId ?? this.noticeId,
    );
  }
}
