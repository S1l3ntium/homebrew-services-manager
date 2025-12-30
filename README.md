# Homebrew Services Manager

A lightweight menu bar application for managing Homebrew services on macOS.

## Features

### 🎯 Core Features
- **Menu Bar Integration** - Always accessible from the menu bar
- **Service List** - Clean, searchable list of all Homebrew services
- **Service Management** - Start, Stop, Restart services with a single click
- **Real-time Status** - Animated indicator showing active operations
- **Desktop Notifications** - Get notified when operations complete
- **Service Details** - View comprehensive information about each service

### 📊 Service Information
- **Status** - Current running state
- **User** - User running the service
- **PID** - Process ID (when running)
- **Version** - Installed package version
- **Auto-start** - Whether service auto-starts on login
- **Config Access** - Direct link to service configuration file
- **Logs Access** - Quick access to service logs

### ⚡ Performance
- **Background Updates** - Refresh happens in background without blocking UI
- **Parallel Version Fetching** - Efficiently loads version info for all services
- **Caching** - Smart caching of Homebrew path for faster operations
- **Async/Await** - Modern Swift concurrency throughout

## Installation

### Install via Homebrew Cask (Recommended)

```bash
brew tap YOUR_USERNAME/tap
brew install --cask homebrew-services-manager
```

See [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions.

### Build from Source

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/homebrew-services-manager.git
cd homebrew-services-manager
```

2. Build the application:
```bash
swift build -c release
```

3. Run the application:

```bash
.build/release/HomebrewServicesManager
```

### Requirements
- macOS 13.0 or later
- Swift 5.8+ (comes with Xcode 14.3+)
- Homebrew installed (for the app to work)

## Usage

1. Run the application
2. Click the menu bar icon (server rack icon)
3. Browse your installed Homebrew services
4. Click on a service to view details
5. Use Start/Stop/Restart buttons to manage services

### Keyboard Shortcuts
- **Cmd+Q** - Quit application (when popover is open)

## Architecture

### Design Pattern
- **MVVM** - Model-View-ViewModel architecture
- **Async/Await** - Modern Swift concurrency
- **Observable** - Combine framework for reactive updates

### Key Components

#### Core Layer (`Sources/Core/`)
- `BrewServiceManager` - Interface to Homebrew CLI
- `Models` - Data structures for services
- `BrewError` - Error handling with LocalizedError

#### App Layer (`Sources/App/`)
- `ServiceListViewModel` - State management
- `MenuBarPopoverView` - Main UI
- `MenuBarController` - Menu bar lifecycle

#### System Layer (`Sources/SystemModule/`)
- `NotificationsManager` - Desktop notifications

### Threading Model
- Main thread: UI updates, animations
- Background tasks: Homebrew operations, version fetching
- Proper cancellation and cleanup on operation completion

## UI/UX

### Design System
- **Liquid Glass** - Modern macOS aesthetic
- **Smooth Animations** - 0.15-0.7s transitions
- **Responsive Feedback** - Hover states, disabled states
- **Dark Mode** - Full support for system dark mode

### Components
- **Service Row** - Full-row clickable with action buttons
- **Service Detail** - Organized information panel
- **Pulse Indicator** - Animated status during operations
- **Glass Buttons** - Modern button styling

## Localization

The application includes a localization framework (`L10n` enum) ready for multi-language support:

```swift
enum L10n {
    static let start = NSLocalizedString("start", value: "Start", comment: "Start action")
    // ... more strings
}
```

Supported/Ready for:
- 🇬🇧 English
- 🇷🇺 Russian
- 🌐 Other languages (infrastructure in place)

## Error Handling

Comprehensive error handling with user-friendly messages:

- **Homebrew Not Found** - Clear instructions to install
- **Execution Failed** - Detailed error messages
- **Authentication Required** - Prompts for admin access
- **Invalid Output** - Graceful degradation

## Development

### Building
```bash
swift build
```

### Running
```bash
swift run HomebrewServicesManager
```

### Testing
```bash
swift test
```

### Code Style
- Swift 5.5+ with modern concurrency
- Proper error handling with LocalizedError
- Clear variable naming and organization
- No forced unwraps or force casts

## Known Limitations

- Requires Homebrew to be installed
- Some operations may require admin password
- Log access depends on service log directory existence

## Future Enhancements

- [ ] Multi-service batch operations (start/stop all)
- [ ] Service filtering by status
- [ ] Custom service groups
- [ ] Keyboard-only navigation
- [ ] Touch Bar support
- [ ] Service settings/configuration UI

## Contributing

Contributions are welcome! Please ensure:
- Clean build with no warnings
- Proper error handling
- Modern async/await patterns
- Meaningful commit messages

## License

[Add your license here]

## Credits

Built with:
- Swift 5.5+
- SwiftUI
- Combine
- macOS AppKit

---

**Version:** 1.0
**Last Updated:** 2025-12-30
**Platform:** macOS 11.0+
