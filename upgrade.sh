#!/bin/bash

CLEANUP=$1
PACKAGES_TO_UPGRADE="${*:2}"
PACKAGE_COUNT="$(( $# - 1 ))"
BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)

if [ -n "$PACKAGES_TO_UPGRADE" ] && [ $PACKAGE_COUNT -gt 0 ]; then
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -title "Homebrew Updating..." \
        -subtitle "Update in progress" \
        -message "Updating $PACKAGE_COUNT formulae..."

    $BREW upgrade $(echo -n "$PACKAGES_TO_UPGRADE")
    BREW_UPGRADE_STATUS=$?
fi

if [ -n "$CLEANUP" ] && $CLEANUP; then
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \¬
        -title "Homebrew Cleaning..." \¬
        -subtitle "Cleanup in progress" \¬
        -message "Removing old versions, downloads, and caches."¬

    $BREW cleanup > /dev/null 2>&1¬
fi

if [ -n "$BREW_UPGRADE_STATUS" ]; then
    if [ $BREW_UPGRADE_STATUS -eq 0 ]; then
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -title "Homebrew Updates Complete" \
            -subtitle "Successfully updated the following formulae:" \
            -message "$PACKAGES_TO_UPGRADE" \
            -sound default \
            -execute "say 🍺"
    else
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -title "Homebrew Updates Failed" \
            -subtitle "Failed to update some or all of the following formulae:" \
            -message "$PACKAGES_TO_UPGRADE" \
            -sound default
    fi
fi
