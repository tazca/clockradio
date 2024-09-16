#!/bin/zsh
flutter clean
dart run flutter_native_splash:create
flutter build linux
