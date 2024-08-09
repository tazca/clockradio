#!/bin/zsh
dart run flutter_native_splash:create
flutter build web --dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/
