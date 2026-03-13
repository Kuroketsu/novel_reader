// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsGoogleFontsGen {
  const $AssetsGoogleFontsGen();

  /// File path: assets/google_fonts/Roboto-Black.ttf
  String get robotoBlack => 'assets/google_fonts/Roboto-Black.ttf';

  /// File path: assets/google_fonts/Roboto-BlackItalic.ttf
  String get robotoBlackItalic => 'assets/google_fonts/Roboto-BlackItalic.ttf';

  /// File path: assets/google_fonts/Roboto-Bold.ttf
  String get robotoBold => 'assets/google_fonts/Roboto-Bold.ttf';

  /// File path: assets/google_fonts/Roboto-BoldItalic.ttf
  String get robotoBoldItalic => 'assets/google_fonts/Roboto-BoldItalic.ttf';

  /// File path: assets/google_fonts/Roboto-Italic.ttf
  String get robotoItalic => 'assets/google_fonts/Roboto-Italic.ttf';

  /// File path: assets/google_fonts/Roboto-Light.ttf
  String get robotoLight => 'assets/google_fonts/Roboto-Light.ttf';

  /// File path: assets/google_fonts/Roboto-LightItalic.ttf
  String get robotoLightItalic => 'assets/google_fonts/Roboto-LightItalic.ttf';

  /// File path: assets/google_fonts/Roboto-Medium.ttf
  String get robotoMedium => 'assets/google_fonts/Roboto-Medium.ttf';

  /// File path: assets/google_fonts/Roboto-MediumItalic.ttf
  String get robotoMediumItalic =>
      'assets/google_fonts/Roboto-MediumItalic.ttf';

  /// File path: assets/google_fonts/Roboto-Regular.ttf
  String get robotoRegular => 'assets/google_fonts/Roboto-Regular.ttf';

  /// File path: assets/google_fonts/Roboto-Thin.ttf
  String get robotoThin => 'assets/google_fonts/Roboto-Thin.ttf';

  /// File path: assets/google_fonts/Roboto-ThinItalic.ttf
  String get robotoThinItalic => 'assets/google_fonts/Roboto-ThinItalic.ttf';

  /// List of all assets
  List<String> get values => [
    robotoBlack,
    robotoBlackItalic,
    robotoBold,
    robotoBoldItalic,
    robotoItalic,
    robotoLight,
    robotoLightItalic,
    robotoMedium,
    robotoMediumItalic,
    robotoRegular,
    robotoThin,
    robotoThinItalic,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.png');

  /// List of all assets
  List<AssetGenImage> get values => [appIcon];
}

class Assets {
  const Assets._();

  static const $AssetsGoogleFontsGen googleFonts = $AssetsGoogleFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
