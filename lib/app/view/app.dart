import 'package:flutter/material.dart';
import 'package:novel_reader/app/router/app_router.dart';
import 'package:novel_reader/app/theme/global_theme.dart';
import 'package:novel_reader/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Novel Reader',
      themeMode: ThemeMode.dark,
      theme: GlobalThemData.lightThemeData,
      darkTheme: GlobalThemData.darkThemeData,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter().config(),
    );
  }
}
