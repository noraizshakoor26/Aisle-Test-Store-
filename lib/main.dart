import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_store/core/services/navigator_service.dart';
import 'package:test_store/core/theme/app_theme.dart';
import 'package:test_store/screens/route_screen/presentator/bloc/route_bloc.dart';
import 'package:test_store/screens/route_screen/presentator/view/route_screen.dart';
import 'package:test_store/screens/sign_in_screen/presentator/bloc/sign_in_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RouteBloc()),
        BlocProvider(create: (context) => SignInBloc()),
      ],
      child: MaterialApp(
        navigatorKey: NavigatorService().navigatorKey,
        title: 'Aisle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RouteScreen(),
      ),
    );
  }
}
