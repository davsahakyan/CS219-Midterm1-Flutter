import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'bloc/homework_bloc.dart';
import 'repository/homework_repository.dart';
import 'pages/home_page.dart';
import 'pages/form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = HomeworkRepository();
  await repo.init();
  runApp(HomeworkApp(repository: repo));
}

class HomeworkApp extends StatelessWidget {
  const HomeworkApp({super.key, required this.repository});
  final HomeworkRepository repository;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeworkListPage(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddHomeworkPage(),
            ),
          ],
        ),
      ],
    );

    return MultiProvider(
      providers: [
        Provider<HomeworkRepository>.value(value: repository),
        BlocProvider(
          create: (context) => HomeworkBloc(context.read<HomeworkRepository>())
            ..add(LoadHomework()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Homework Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}