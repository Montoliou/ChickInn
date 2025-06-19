# ChickInn 🐔🥚

SwiftUI iOS 17 sample app for tracking your backyard flock.

To build:

```bash
brew install xcodegen    # if not installed
cd ChickInn
xcodegen generate
open ChickInn.xcodeproj
```

## iCloud & CloudKit set‑up
1. In Xcode > Signing & Capabilities add **iCloud** and enable **CloudKit** with **Use default container**.
2. In the CloudKit Dashboard create a **Shared Database** zone called **EggTrackerShare**.
3. Run on a real device signed into iCloud; invite a second Apple‑ID via the built‑in share sheet (Settings tab) to verify Family Sharing.

## Seed data
On first launch the app checks `SeedData/seed.json` and inserts demo content (3 chickens, 20 eggs, 1 moult, 1 medication).

## Tests
Run **Cmd‑U**. Coverage target ≥80 %.

Happy hatching! 🐣
