import 'package:demo_frontend/providers/auth_provider.dart';
import 'package:demo_frontend/providers/notes_provider.dart';
import 'package:demo_frontend/routes/router_delegate.dart';
import 'package:demo_frontend/routes/router_parser.dart';
import 'package:demo_frontend/services/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await HiveBoxes.registerAdapters();
  await HiveBoxes.openBoxes();
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

  _appInit() async {
    await Future.delayed(const Duration(seconds: 2));

    await ref.read(authProvider.notifier).init();
    await ref.read(notesProvider.notifier).init();
  }

  @override
  void initState() {
    _appInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _routerDelegate = AppRouterDelegate(ref: ref);
    return MaterialApp.router(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: _routerParser,
      routerDelegate: _routerDelegate,
    );
  }
}
