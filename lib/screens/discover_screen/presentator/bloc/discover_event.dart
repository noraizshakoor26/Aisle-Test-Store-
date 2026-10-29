part of 'discover_bloc.dart';

abstract class DiscoverEvent {}

class DiscoverStarted extends DiscoverEvent {}

class DiscoverRefreshed extends DiscoverEvent {
  final Completer<void> completer;

  DiscoverRefreshed(this.completer);
}

class DiscoverRetried extends DiscoverEvent {}

class DiscoverNextPageRequested extends DiscoverEvent {
  final bool isRetry;

  DiscoverNextPageRequested({this.isRetry = false});
}

class DiscoverSearchChanged extends DiscoverEvent {
  final String query;

  DiscoverSearchChanged(this.query);
}

class DiscoverCategorySelected extends DiscoverEvent {
  final String? slug;

  DiscoverCategorySelected(this.slug);
}
