import 'package:demo_frontend/routes/router_delegate.dart';
import 'package:demo_frontend/routes/router_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(const ProviderScope(child: NotesApp()));
}

class NotesApp extends ConsumerStatefulWidget {
  const NotesApp({super.key});

  @override
  ConsumerState<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends ConsumerState<NotesApp> {
  final AppRouterParser _routerParser = AppRouterParser();
  late AppRouterDelegate _routerDelegate;
  @override
  Widget build(BuildContext context) {
    _routerDelegate = AppRouterDelegate(ref: ref);
    return MaterialApp.router(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: _routerParser,
      routerDelegate: _routerDelegate,
    );
  }
}
