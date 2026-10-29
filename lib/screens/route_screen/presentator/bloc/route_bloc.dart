import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/services/navigator_service.dart';
import 'package:test_store/core/services/secure_storage_service.dart';
import 'package:test_store/screens/discover_screen/presentator/view/discover_screen.dart';
import 'package:test_store/screens/route_screen/data/repository/route_remote_repo_impl.dart';
import 'package:test_store/screens/route_screen/domain/usecases/get_me_usecase.dart';
import 'package:test_store/screens/welcome_screen/presentator/view/welcome_screen.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(const RouteState()) {
    on<RouteStarted>(_onStarted);
    on<RouteSignedOut>(_onSignedOut);
  }

  Future<void> _onStarted(RouteStarted event, Emitter<RouteState> emit) async {
    emit(state.copyWith(status: StatusIndicator.loading));

    // Holding the splash until the brand fonts are ready stops every screen
    // after it from re-laying out when the fallback font swaps.
    await GoogleFonts.pendingFonts().timeout(
      const Duration(seconds: 3),
      onTimeout: () => [],
    );

    final session = await SecureStorageService().readUserSession();
    if (session == null) {
      emit(state.copyWith(status: StatusIndicator.active));
      NavigatorService().pushAndRemoveUntil(const WelcomeScreen(), fade: true);
      return;
    }

    final result = await GetMeUseCase(RouteRemoteRepoImpl()).execute();
    final isExpired = result.isFailure && result.failure is UnauthorizedFailure;
    if (isExpired) {
      await SecureStorageService().clearUserSession();
    }
    emit(state.copyWith(status: StatusIndicator.active));
    NavigatorService().pushAndRemoveUntil(
      isExpired ? const WelcomeScreen() : const DiscoverScreen(),
      fade: true,
    );
  }

  Future<void> _onSignedOut(
    RouteSignedOut event,
    Emitter<RouteState> emit,
  ) async {
    await SecureStorageService().clearUserSession();
    NavigatorService().pushAndRemoveUntil(const WelcomeScreen(), fade: true);
  }
}
