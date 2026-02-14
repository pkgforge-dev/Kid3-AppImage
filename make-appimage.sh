#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q kid3 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/kid3.png
export DESKTOP=/usr/share/applications/org.kde.kid3.desktop
export PATH_MAPPING='/usr/share/kid3:${SHARUN_DIR}/share/kid3'
export DEPLOY_QML=1

# Deploy dependencies
quick-sharun /usr/bin/kid3 /usr/share/kxmlgui5

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
