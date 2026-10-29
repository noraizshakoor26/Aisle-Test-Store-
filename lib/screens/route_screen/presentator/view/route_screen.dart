import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_store/core/widgets/aisle_wordmark.dart';
import 'package:test_store/screens/route_screen/presentator/bloc/route_bloc.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RouteBloc>().add(RouteStarted());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AisleWordmark(fontSize: 34)));
  }
}
