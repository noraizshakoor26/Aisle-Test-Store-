import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/api/result.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/discover_screen/data/models/category_model.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';
import 'package:test_store/screens/discover_screen/presentator/bloc/discover_bloc.dart';

class PageRequest {
  PageRequest({required this.skip, this.query, this.slug});

  final int skip;
  final String? query;
  final String? slug;
  final _completer = Completer<Result<ProductsResponseModel>>();

  void succeed({required int firstId, required int total}) {
    _completer.complete(
      Result.success(
        ProductsResponseModel(
          products: products(firstId, kPageSize),
          total: total,
          skip: skip,
          limit: kPageSize,
        ),
      ),
    );
  }

  void fail() => _completer.complete(
    Result.failure(const NetworkFailure('No internet connection.')),
  );
}

class FakeDiscoverRepository implements DiscoverRepository {
  final requests = <PageRequest>[];

  PageRequest get last => requests.last;

  Future<Result<ProductsResponseModel>> _record(PageRequest request) {
    requests.add(request);
    return request._completer.future;
  }

  @override
  Future<Result<ProductsResponseModel>> getProducts({
    required int limit,
    required int skip,
  }) => _record(PageRequest(skip: skip));

  @override
  Future<Result<ProductsResponseModel>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) => _record(PageRequest(skip: skip, query: query));

  @override
  Future<Result<ProductsResponseModel>> getProductsByCategory({
    required String slug,
    required int limit,
    required int skip,
  }) => _record(PageRequest(skip: skip, slug: slug));

  @override
  Future<Result<List<CategoryModel>>> getCategories() async =>
      Result.success([CategoryModel(slug: 'beauty', name: 'Beauty')]);

  @override
  Future<Result<List<ProductModel>>> getDeals({required int limit}) async =>
      Result.success(products(900, limit));
}

List<ProductModel> products(int firstId, int count) => [
  for (var id = firstId; id < firstId + count; id++)
    ProductModel.fromMap({'id': id}),
];

List<int> ids(DiscoverState state) =>
    state.products.map((product) => product.id).toList();

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  late FakeDiscoverRepository repository;
  late DiscoverBloc bloc;

  setUp(() {
    repository = FakeDiscoverRepository();
    bloc = DiscoverBloc(repository: repository);
  });

  tearDown(() => bloc.close());

  Future<void> loadFirstPage({int total = 100}) async {
    bloc.add(DiscoverStarted());
    await settle();
    repository.last.succeed(firstId: 1, total: total);
    await settle();
  }

  Future<void> loadNextPage({required int firstId}) async {
    bloc.add(DiscoverNextPageRequested());
    await settle();
    repository.last.succeed(firstId: firstId, total: 100);
    await settle();
  }

  Future<void> refresh() async {
    bloc.add(DiscoverRefreshed(Completer<void>()));
    await settle();
  }

  group('loading and paging', () {
    test('start loads the first page, categories and deals', () async {
      await loadFirstPage();

      expect(bloc.state.status, StatusIndicator.active);
      expect(bloc.state.products, hasLength(kPageSize));
      expect(bloc.state.categoriesStatus, StatusIndicator.active);
      expect(bloc.state.dealsStatus, StatusIndicator.active);
    });

    test('the next page skips what is already loaded and appends', () async {
      await loadFirstPage();
      await loadNextPage(firstId: 21);

      expect(repository.last.skip, kPageSize);
      expect(ids(bloc.state), [for (var id = 1; id <= 40; id++) id]);
      expect(bloc.state.pageStatus, StatusIndicator.idle);
    });

    test('no page is requested once the end is reached', () async {
      await loadFirstPage(total: kPageSize);

      bloc.add(DiscoverNextPageRequested());
      await settle();

      expect(repository.requests, hasLength(1));
    });

    test('a failed page only retries when asked to', () async {
      await loadFirstPage();
      bloc.add(DiscoverNextPageRequested());
      await settle();
      repository.last.fail();
      await settle();

      expect(bloc.state.pageStatus, StatusIndicator.failed);

      bloc.add(DiscoverNextPageRequested());
      await settle();
      expect(repository.requests, hasLength(2));

      bloc.add(DiscoverNextPageRequested(isRetry: true));
      await settle();
      expect(repository.requests, hasLength(3));
      expect(bloc.state.pageStatus, StatusIndicator.loadingMore);
    });

    test('a late response for an old search is ignored', () async {
      await loadFirstPage();
      bloc.add(DiscoverSearchChanged('phone'));
      await settle();
      final oldSearch = repository.last;
      bloc.add(DiscoverSearchChanged('laptop'));
      await settle();
      final newSearch = repository.last;

      newSearch.succeed(firstId: 500, total: 100);
      await settle();
      oldSearch.succeed(firstId: 300, total: 100);
      await settle();

      expect(bloc.state.query, 'laptop');
      expect(bloc.state.products.first.id, 500);
    });
  });

  group('refresh while paging', () {
    test('a failed refresh does not leave load more stuck', () async {
      await loadFirstPage();
      bloc.add(DiscoverNextPageRequested());
      await settle();
      final page = repository.last;

      await refresh();
      repository.last.fail();
      await settle();
      page.succeed(firstId: 21, total: 100);
      await settle();

      expect(bloc.state.pageStatus, StatusIndicator.idle);
      expect(bloc.state.products, hasLength(kPageSize));
      expect(bloc.state.noticeId, 1);

      bloc.add(DiscoverNextPageRequested());
      await settle();
      expect(repository.last.skip, kPageSize);
      expect(bloc.state.pageStatus, StatusIndicator.loadingMore);
    });

    test('a page that started before a refresh is dropped', () async {
      await loadFirstPage();
      bloc.add(DiscoverNextPageRequested());
      await settle();
      final page = repository.last;

      await refresh();
      repository.last.succeed(firstId: 101, total: 100);
      await settle();
      page.succeed(firstId: 21, total: 100);
      await settle();

      expect(ids(bloc.state), [for (var id = 101; id <= 120; id++) id]);
      expect(bloc.state.pageStatus, StatusIndicator.idle);
    });

    test('paging waits until a running refresh finishes', () async {
      await loadFirstPage();
      await loadNextPage(firstId: 21);

      await refresh();
      final refreshPage = repository.last;
      bloc.add(DiscoverNextPageRequested());
      await settle();

      expect(repository.last, same(refreshPage));

      refreshPage.succeed(firstId: 101, total: 100);
      await settle();
      await loadNextPage(firstId: 121);

      expect(ids(bloc.state), [for (var id = 101; id <= 140; id++) id]);
    });

    test('a search during a refresh can page straight away', () async {
      await loadFirstPage();
      await refresh();
      bloc.add(DiscoverSearchChanged('phone'));
      await settle();
      repository.last.succeed(firstId: 300, total: 100);
      await settle();

      bloc.add(DiscoverNextPageRequested());
      await settle();

      expect(repository.last.query, 'phone');
      expect(repository.last.skip, kPageSize);
    });

    test('refresh completes its completer when done', () async {
      await loadFirstPage();
      final completer = Completer<void>();
      bloc.add(DiscoverRefreshed(completer));
      await settle();
      repository.last.fail();

      await expectLater(completer.future, completes);
    });
  });
}
