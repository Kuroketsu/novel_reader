import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:novel_reader/l10n/l10n.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: const AutoRouter(),
    );
  }
}
