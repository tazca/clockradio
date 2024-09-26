#!/bin/zsh
flutter clean
dart run flutter_native_splash:create
flutter build web --dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/ --web-renderer=auto
