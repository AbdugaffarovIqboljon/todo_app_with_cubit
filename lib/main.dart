import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:learn_bloc/cubit/detail_cubit/detail_cubit.dart';
import 'package:learn_bloc/cubit/home_cubit/home_cubit.dart';
import 'package:learn_bloc/cubit/theme_cubit/theme_cubit.dart';
import 'package:learn_bloc/cubit/theme_cubit/theme_state.dart';
import 'package:learn_bloc/pages/detail_page.dart';
import 'package:learn_bloc/pages/home_page.dart';
import 'package:learn_bloc/service/sql_service.dart';

/// service locator
final sql = SQLService();

final homeCubit = HomeCubit();

final detailCubit = DetailCubit();

final themeController = ThemeCubit(ThemeState());

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeState>(
      stream: themeController.stream,
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: themeController.state.mode,
          initialRoute: "/",
          routes: {
            "/": (context) => const HomePage(),
            "/detail": (context) => DetailPage(),
          },
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
        );
      },
    );
  }
}
