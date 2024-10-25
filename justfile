set positional-arguments

default: dev

dev:
  bun start

build:
  bunx react-native build-android --mode=release --tasks 'assembleRelease';

clean:
  cd android && ./gradlew clean;
  # bunx react-native clean;

apks:
  @echo "=== Generated APKs ==="
  ls -la android/app/build/outputs/apk/* 2>/dev/null || true

install:
  #!/usr/bin/env bash
  apk="$(ls android/app/build/outputs/apk/**/*.apk | fzf)";
  if ! [ -z "$apk" ]; then
    adb install "$apk" && just open;
  fi;

open:
  adb shell am start -a android.intent.action.MAIN -n dev.ediblemonad.daftlauncher/.MainActivity;

android-setup:
  sdkmanager "$MY_ANDROID_AVD_PKG" && \
    avdmanager create avd -n daft -k "$MY_ANDROID_AVD_PKG" --device 26 --force;

emu:
  emulator -gpu swiftshader_indirect @daft

