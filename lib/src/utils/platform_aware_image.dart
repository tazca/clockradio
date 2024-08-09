import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// https://stackoverflow.com/questions/61301598/how-can-i-display-asset-images-on-flutter-web
/// Mobile safari requires using Image.network instead of Image.asset
class PlatformAwareImageAsset extends StatelessWidget {
  const PlatformAwareImageAsset(
    this.asset, {
    super.key,
    this.package,
  });

  final String asset;
  final String? package;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        'assets/${package == null ? '' : 'packages/$package/'}$asset',
      );
    }

    return Image.asset(
      asset,
      package: package,
    );
  }
}

ImageProvider platformAwareImageProvider(String asset, {String? package}) {
  if (kIsWeb) {
    return NetworkImage(
      scale: 1.0,
      'assets/${package == null ? '' : 'packages/$package/'}$asset',
    );
  }

  return AssetImage(
    asset,
    package: package,
  );
}
