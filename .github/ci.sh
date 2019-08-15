#!/bin/sh

set -e
brew update
HOMEBREW_TAP_DIR="/usr/local/Homebrew/Library/Taps/jonchang/homebrew-biology"
mkdir -p "$HOMEBREW_TAP_DIR"
rm -rf "$HOMEBREW_TAP_DIR"
ln -s "$PWD" "$HOMEBREW_TAP_DIR"
if [ -z "$SYSTEM_PULLREQUEST_TARGETBRANCH" ]; then export SYSTEM_PULLREQUEST_TARGETBRANCH="origin/master"; fi
brew test-bot --tap="jonchang/biology" --root-url=https://dl.bintray.com/jonchang/bottles-biology
