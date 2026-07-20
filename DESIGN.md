# Kotoba Implementation Plan (v1)

This implementation plan is organized into small, testable milestones. At the end of every milestone, the application should remain in a runnable state.

---

# Milestone 1 – Project Skeleton

**Goal:** Create a working macOS application with the basic architecture.

## Tasks

* Create a new SwiftUI macOS app
* Configure as a menu bar application (no Dock icon)
* Add required packages

  * KeyboardShortcuts
* Create project structure

```
Kotoba/

    App/

    Window/

    Hotkey/

    Selection/

    Lookup/

    Models/

    Services/

    Resources/
```

## Deliverable

Launching the app creates a menu bar icon.

---

# Milestone 2 – Floating Window

**Goal:** Build the permanent companion window.

Requirements

* Floating window
* Always on top
* Appears in upper-right corner
* Hidden title bar
* Rounded corners
* Doesn't become key unless clicked
* Remember Compact vs Expanded mode

### Window Manager

Responsible for

* Creating the window
* Positioning it
* Showing/hiding
* Resizing

Interface

```swift
class WindowManager {

    func show()

    func hide()

    func update(result: LookupResult)

    func setMode(.compact)

    func setMode(.expanded)
}
```

---

# Milestone 3 – UI

Build both layouts before any backend work.

## Compact

Displays

```
募集

ぼしゅう
[0]

Recruitment
Solicitation

JLPT N3
★★★★★
```

No scrolling.

---

## Expanded

Displays

* Kanji
* Reading
* Pitch Accent
* POS
* Definitions
* Examples
* Frequency
* JLPT

Scrollable if necessary.

---

## Shared ViewModel

```
LookupViewModel

currentResult

displayMode

isLoading

error
```

---

# Milestone 4 – Hotkey

Install

KeyboardShortcuts

Register

```
⌥⌘J
```

Behavior

```
Shortcut pressed

↓

SelectionService

↓

LookupProvider

↓

WindowManager.update()
```

For now

Use fake lookup data.

---

# Milestone 5 – Selection Service

Probably the trickiest piece.

Responsibilities

```
Read currently selected text.
```

Implementation order

## Attempt 1

Accessibility API

```
AXUIElement
```

Retrieve

```
kAXSelectedTextAttribute
```

If unavailable

Return nil.

Interface

```swift
protocol SelectionProvider {

    func selectedText() -> String?
}
```

---

# Milestone 6 – Lookup Provider

Initially

Hardcode data.

```
募集

↓

LookupResult(...)
```

Purpose

Allows UI development independently.

Protocol

```swift
protocol LookupProvider {

    func lookup(_ text: String) async throws -> LookupResult
}
```

---

# Milestone 7 – Online Dictionary

Replace fake provider.

Possible choices

* Jotoba
* JMdict endpoint
* Custom API

Provider

```
OnlineLookupProvider
```

Responsibilities

* HTTP request
* Decode JSON
* Map to LookupResult

No UI changes.

---

# Milestone 8 – Error Handling

Cases

No selection

```
No text selected.
```

Dictionary failure

```
Unable to lookup word.
```

Network unavailable

```
Offline.
```

Window should display errors instead of alerts.

---

# Milestone 9 – Compact / Expanded

Implement

Button

```
▼
```

Compact

↓

Expanded

Window animates smoothly.

Persist

```
UserDefaults
```

---

# Models

## LookupResult

```swift
struct LookupResult {

    let word: String

    let reading: String

    let pitchAccent: String?

    let definitions: [String]

    let partOfSpeech: [String]

    let jlpt: String?

    let frequency: Int?

    let examples: [ExampleSentence]
}
```

---

## ExampleSentence

```swift
struct ExampleSentence {

    let japanese: String

    let english: String
}
```

---

# Folder Structure

```
Kotoba

├── App
│   └── KotobaApp.swift
│
├── Models
│   ├── LookupResult.swift
│   └── ExampleSentence.swift
│
├── Window
│   ├── WindowManager.swift
│   ├── FloatingWindow.swift
│   ├── CompactView.swift
│   ├── ExpandedView.swift
│   └── LookupViewModel.swift
│
├── Hotkey
│   └── HotkeyManager.swift
│
├── Selection
│   ├── SelectionProvider.swift
│   └── AccessibilitySelectionProvider.swift
│
├── Lookup
│   ├── LookupProvider.swift
│   ├── MockLookupProvider.swift
│   └── OnlineLookupProvider.swift
│
├── Services
│
└── Resources
```

---

# Data Flow

```
⌥⌘J

↓

HotkeyManager

↓

SelectionProvider

↓

LookupProvider

↓

LookupResult

↓

LookupViewModel

↓

SwiftUI Views

↓

Floating Window
```

Only one direction.

No circular dependencies.

---

# Dependency Graph

```
App
 │
 ▼
HotkeyManager
 │
 ▼
SelectionProvider
 │
 ▼
LookupProvider
 │
 ▼
ViewModel
 │
 ▼
SwiftUI Views
```

The UI never talks directly to the lookup implementation.

---

# Stretch Goals (Post-v1)

Once the core experience is solid, we can prioritize enhancements that add significant value without changing the architecture:

1. **Offline dictionary database** (SQLite with JMdict, pitch accent, JLPT, and frequency data) to eliminate network dependency.
2. **Deinflection engine** so conjugated forms like `誘えば` resolve correctly to `誘う`.
3. **Grammar breakdown** for short phrases and sentences.
4. **OCR mode** for images, manga, and PDFs without selectable text.
5. **Anki export** for one-click vocabulary mining.
6. **AI explanations** for grammar and nuanced usage.

## Guiding Principle

Every feature should preserve Kotoba's defining workflow:

> **Select text → Press one shortcut → Instantly glance at the companion window → Continue reading.**

If a feature interrupts or complicates that flow, it should be reconsidered or deferred. The application should always feel like a lightweight companion rather than a destination in itself.

