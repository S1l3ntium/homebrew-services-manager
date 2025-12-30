Xcode integration — Quick steps

This folder contains scaffold files to create a macOS App target in Xcode and integrate this Swift Package.

Files included:

- `Info.plist` — minimal Info.plist for the macOS App target.
- `Entitlements.plist` — placeholder entitlements (update for SMJobBless and signing).
- `Assets.xcassets` — AppIcon placeholder asset catalog.

Recommended steps to create an Xcode macOS App target:

1. Open Xcode and choose `File → New → Project...` → `App` (macOS).
2. Set Product Name: `HomebrewServicesManager`, Interface: `SwiftUI`, Language: `Swift`.
3. After creating the project, remove the default files and add the `Sources/App` files into the new App target (or add this package as a local Swift Package dependency):
   - `File → Add Packages...` and choose the repository folder or `Add Local Package` → select this repository's `Package.swift`.
   - In the App target's Frameworks and Libraries, add the package product `HomebrewServicesManager` (the `App` target) or link `Core` and `SystemModule` as needed.
4. In your App target settings:
   - Set the `Info.plist` file path to the provided `Xcode/Info.plist` (or copy its contents to the project's `Info.plist`).
   - In `Signing & Capabilities`, add the `Entitlements.plist` content as the entitlements file and configure your Developer Team.
   - Add the `Assets.xcassets` folder to the project (drag into Project navigator).
5. Configure capabilities needed later (for SMJobBless, you will need proper code signing, an Installer certificate, and a helper target).

Run the app:

```bash
# From the repo root you can run the SPM-built app (limited):
swift run HomebrewServicesManager
```

For a real App bundle and code signing, prefer running from Xcode and configuring signing with your Developer ID certificate.

Notes:

- Use the provided `Sources/App` SwiftUI files as the app code. If you add a new Xcode App target, either add the package as a local Swift Package dependency or copy these sources into your project target.
- For debugging `brew` interactions the app will call Homebrew via `Process()`; ensure the `brew` binary is available in the runtime PATH (Xcode run scheme may need PATH configuration).
- For actions requiring root (e.g., manipulating system plists), implement an SMJobBless helper target (see `SystemModule/PrivilegedHelper` planning) and keep dangerous operations signed and gated behind user consent.

If you want, I can now:

- Add the UI controls to start/stop/restart services and wire them to the `Core` manager (I can implement this next).
- Create an SMJobBless scaffolding and documentation for signing/entitlements.
