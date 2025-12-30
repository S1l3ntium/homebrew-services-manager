#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Checking project structure..."
echo ""

ERRORS=0

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1"
    else
        echo "❌ Missing: $1"
        ERRORS=$((ERRORS + 1))
    fi
}

# Check Package.swift
check_file "Package.swift"

# Check build script
check_file "build.sh"

# Check Core module
echo ""
echo "Core module:"
check_file "Sources/Core/Models.swift"
check_file "Sources/Core/BrewServiceManager.swift"

# Check CLI module
echo ""
echo "CLI module:"
check_file "Sources/CLI/main.swift"

# Check App module
echo ""
echo "App module:"
check_file "Sources/App/MainApp.swift"
check_file "Sources/App/ServiceListView.swift"
check_file "Sources/App/ServiceDetailView.swift"
check_file "Sources/App/ServiceListViewModel.swift"
check_file "Sources/App/MenuBarController.swift"
check_file "Sources/App/MenuBarPopoverView.swift"
check_file "Sources/App/FocusableTextField.swift"

# Check SystemModule
echo ""
echo "SystemModule:"
check_file "Sources/SystemModule/NotificationsManager.swift"
check_file "Sources/SystemModule/Dummy.swift"

# Check Tests
echo ""
echo "Tests:"
check_file "Tests/CoreTests/BrewServiceManagerTests.swift"

# Check if brew is installed
echo ""
echo "🍺 Checking Homebrew installation:"
if command -v brew >/dev/null 2>&1; then
    BREW_PATH=$(which brew)
    echo "✅ Homebrew found at: $BREW_PATH"
    BREW_VERSION=$(brew --version | head -n 1)
    echo "   Version: $BREW_VERSION"
else
    echo "❌ Homebrew not found in PATH"
    echo "   Install from: https://brew.sh"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    echo "✅ All checks passed! Project structure is correct."
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./build.sh"
    echo "  2. Test CLI: ./dist/hsmanager-cli"
    echo "  3. Or use Makefile: make build"
    exit 0
else
    echo "❌ Found $ERRORS error(s)"
    echo ""
    echo "Please ensure all required files are in place."
    exit 1
fi
