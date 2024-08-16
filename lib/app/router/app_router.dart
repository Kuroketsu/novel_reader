import 'package:auto_route/auto_route.dart';
import 'package:novel_reader/app/router/app_router.gr.dart';

// see tutorial: https://www.youtube.com/watch?v=Th83H6qv4Z8&ab_channel=NepaliProgrammer
// generate routes: dart run build_runner build -d
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          children: [
            AutoRoute(
              path: 'text_to_speech',
              page: TextToSpeechRoute.page,
              initial: true,
            ),
          ],
        ),
      ];
}
