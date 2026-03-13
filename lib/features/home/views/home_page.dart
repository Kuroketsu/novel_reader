import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:novel_reader/app/router/app_router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novel Reader'),
      ),
      drawer: const NavigationDrawer(),
      body: const AutoRouter(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Novel Reader',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Browser'),
            onTap: () async {
              Navigator.pop(context);
              await context.navigateTo(const BrowserRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Text to Speech'),
            onTap: () async {
              Navigator.pop(context);
              await context.navigateTo(const TextToSpeechRoute());
            },
          ),
        ],
      ),
    );
  }
}
