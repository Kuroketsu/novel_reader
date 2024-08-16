// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:novel_reader/common/view/home.dart' as _i1;
import 'package:novel_reader/text_to_speech/view/text_to_speech_page.dart'
    as _i2;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i3.PageRouteInfo<void> {
  const HomeRoute({List<_i3.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.TextToSpeechPage]
class TextToSpeechRoute extends _i3.PageRouteInfo<void> {
  const TextToSpeechRoute({List<_i3.PageRouteInfo>? children})
      : super(
          TextToSpeechRoute.name,
          initialChildren: children,
        );

  static const String name = 'TextToSpeechRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.TextToSpeechPage();
    },
  );
}
