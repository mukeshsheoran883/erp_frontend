import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final GoRouterState state;
  final String? error;
  const ErrorScreen({super.key, required this.state, this.error});

  @override
  Widget build(BuildContext context) {
    final String? error = state.extra.runtimeType == String ? state.extra.toString() : null;

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text('Error: ${error ?? (kDebugMode ? state.error.toString() : '--')}'),
    );
  }
}
