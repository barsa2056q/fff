#!/usr/bin/env bash
set -euo pipefail

# Скрипт устанавливает Android SDK command-line tools, platform-tools, платформу и build-tools.
# Ожидает, что переменная ANDROID_SDK_ROOT указана в окружении (или задаёт дефолт).
: "${ANDROID_SDK_ROOT:=/usr/local/android-sdk}"

echo "Install Android SDK into: $ANDROID_SDK_ROOT"

mkdir -p "$ANDROID_SDK_ROOT"
cd "$ANDROID_SDK_ROOT"

# Скачиваем command-line tools (версию можно поменять при необходимости)
CLI_ZIP_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
TMP_ZIP="$(mktemp /tmp/cmdline-tools-XXXX.zip)"

echo "Downloading command line tools..."
wget -q --show-progress "$CLI_ZIP_URL" -O "$TMP_ZIP"

echo "Unpacking..."
unzip -q "$TMP_ZIP" -d "$ANDROID_SDK_ROOT/cmdline-tools-temp"
rm -f "$TMP_ZIP"

# Структурируем папку как cmdline-tools/latest
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools/latest"
# move everything from temp into latest (handles различия в архиве)
shopt -s dotglob || true
mv "$ANDROID_SDK_ROOT/cmdline-tools-temp"/* "$ANDROID_SDK_ROOT/cmdline-tools/latest/" || true
rmdir "$ANDROID_SDK_ROOT/cmdline-tools-temp" 2>/dev/null || true

export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
export ANDROID_SDK_ROOT

echo "Installing sdk packages (platform-tools, platforms;android-33, build-tools;33.0.2)..."
yes | sdkmanager --sdk_root="$ANDROID_SDK_ROOT" "platform-tools" "platforms;android-33" "build-tools;33.0.2" >/dev/null

echo "Accepting licenses..."
yes | sdkmanager --sdk_root="$ANDROID_SDK_ROOT" --licenses >/dev/null || true

echo "Android SDK installed at $ANDROID_SDK_ROOT"
echo "Add to PATH: $ANDROID_SDK_ROOT/platform-tools and $ANDROID_SDK_ROOT/cmdline-tools/latest/bin"