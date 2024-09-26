#!/bin/sh
flutter clean
dart run flutter_native_splash:create
flutter build apk
