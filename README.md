# Checkiday

A macOS menu bar app that shows you today's holidays from [checkiday.com](https://www.checkiday.com).

![macOS](https://img.shields.io/badge/macOS-26+-blue) ![Swift](https://img.shields.io/badge/Swift-6.2-orange)

## Features

- Lives in the system tray — no dock icon, no main window
- Displays today's holidays as clickable links (opens in browser)
- Auto-refreshes every hour
- Caches the last successful response for instant display on launch
- macOS notifications on API errors
- Launch at login support
- Keyboard shortcuts: `⌘R` refresh, `⌘Q` quit

## Architecture

```
checkiday-app/          ← Xcode project (menu bar app)
├── CheckidayApp        ← Entry point, MenuBarExtra scene
├── ContentView         ← Menu bar dropdown UI
├── CheckidayViewModel  ← Data fetching, caching, auto-refresh
├── UserNotifications   ← macOS notification helpers
└── CheckidayServiceMock ← Mock for previews (debug only)

checkiday-kit/          ← Local Swift package (API client)
├── Models/
│   ├── Checkiday       ← API response model
│   └── Holiday         ← Single holiday entry
├── Services/
│   ├── CheckidayServiceProtocol ← Abstraction for DI
│   └── CheckidayService         ← Live API client
└── Errors/
    └── APIError        ← Network/API error types
```

## Requirements

- macOS 26+
- Xcode 26+
- Swift 6.2

## Setup

1. Clone this repo and `checkiday-kit` side by side:
   ```
   apps/
   ├── checkiday-app/
   └── checkiday-kit/
   ```
2. Open `Checkiday.xcodeproj` in Xcode
3. Build and run (⌘R)

The local package reference expects `checkiday-kit` at `../checkiday-kit` relative to the project.

## Build Numbering

Build numbers auto-increment via `version.sh` in the scheme's build pre-action. Format: `YYYYMMDDC` where `C` is a counter for builds on the same day.

Version is managed in `Config.xcconfig`.

## Dependencies

| Package | Purpose |
|---------|---------|
| [LaunchAtLogin-Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern) | "Launch at login" toggle |
| CheckidayKit (local) | API client and models |
