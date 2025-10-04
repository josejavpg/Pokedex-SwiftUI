# Project Setup

## Requirements
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (install with `brew install xcodegen`)
- Xcode 16 or newer with Swift 6 toolchain

## Generating the Xcode Project
```sh
make project
```
This invokes `xcodegen generate --spec project.yml` and produces `Pokedex-SwiftUI.xcodeproj`, which is omitted from version control. Re-run the command whenever you add targets, files, or dependencies to keep the project in sync.

## Package Dependencies
The app integrates a local Swift Package (`Packages/Package.swift`) that provides all feature and infrastructure modules. The XcodeGen spec links the required products automatically; no additional configuration inside Xcode is necessary after regeneration.
