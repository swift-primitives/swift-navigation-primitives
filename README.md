# swift-navigation-primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The navigation-state algebra — identified destination placement, ordered stacks, and
shell-independent presentation — as pure values with no runtime attached.

---

## Key Features

- **Placement is identified** — `Navigation.Destination` pairs your own destination value with a
  `Navigation.Identity`, so two visits to the same place stay distinguishable and "go back to that
  one" means something.
- **Identities are minted, never guessed** — `Navigation.Source` is a value that mints in
  strictly increasing order from zero and never recycles, so replayed state is bit-identical and a
  stale reference can never alias a newer placement.
- **Stacks enforce their one invariant** — identities are unique within a `Navigation.Stack`, which
  is what makes `pop(to:)` total: either the placement is there and becomes the top, or nothing is
  removed and the call throws.
- **Presentation carries no widget vocabulary** — `Navigation.Presentation` says whether the
  presenter stays interactive and who may end the presentation, and nothing else. No sheets, no
  popovers, no framework taxonomy leaking into state a server or browser also folds.
- **Values throughout** — every type is `Equatable`, `Hashable`, and `Sendable` exactly when your
  destination value is. Copies are independent; equality is structural.
- **Typed throws** — every failure is a `Navigation.Error`, and every throwing operation leaves its
  receiver untouched.

---

## Quick Start

```swift
import Navigation_Primitives

enum Screen: Hashable, Sendable {
    case list
    case detail(Int)
}

var source = Navigation.Source()
var stack = Navigation.Stack<Screen>()

let list = Navigation.Destination(identity: source.mint(), value: Screen.list)
try stack.push(list)
try stack.push(Navigation.Destination(identity: source.mint(), value: .detail(7)))
try stack.push(Navigation.Destination(identity: source.mint(), value: .detail(7)))

stack.count        // 3 — the same destination, two distinct visits
stack.top?.value   // .detail(7)

// Return to a specific earlier placement, not to "the first .detail".
try stack.pop(to: list.identity)
stack.count        // 1

// How one destination is shown over another, in terms every shell shares.
let sheet = Navigation.Presentation(mode: .modal, dismissal: .user)
let inspector = Navigation.Presentation(mode: .modeless, dismissal: .user)
```

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-navigation-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Navigation Primitives", package: "swift-navigation-primitives")
    ]
)
```

Requires Swift 6.3.3. Platform minimums: macOS 26, iOS 26, tvOS 26, watchOS 26, visionOS 26. The
package's only dependency is `swift-tagged-primitives`, which it re-exports; it imports no
Foundation and uses no reflection or Objective-C interop. Its Embedded build is verified in CI, as
is the dependency's.

---

## Architecture

One library product over a single source module.

| Product | When to import |
|---------|----------------|
| `Navigation Primitives` | Describing navigation state as values, in any execution context. |

Key types in the `Navigation` namespace:

| Type | Purpose |
|------|---------|
| `Navigation.Identity` | Names one *occurrence* of a destination, never the destination itself. A `Tagged<Navigation, UInt64>` — the ecosystem already owns phantom-typed value wrappers. |
| `Navigation.Source` | Mints identities in strictly increasing order; a value, so state stays reproducible. |
| `Navigation.Destination` | One placement: an identity plus your own destination value. |
| `Navigation.Stack` | An ordered run of placements with unique identities; a `RandomAccessCollection`. |
| `Navigation.Presentation` | How one destination is shown over another: a mode and a dismissal authority. |
| `Navigation.Presentation.Mode` | `.modal` — the presenter is inert. `.modeless` — the presenter stays live. |
| `Navigation.Presentation.Dismissal` | `.user` — the person may end it, so unsolicited dismissals are legal state. `.program` — only the program ends it. |
| `Navigation.Error` | `.unknown`, `.duplicate`, `.occupied`; the only ways a placement operation fails. |

### Why there is no widget vocabulary

Sheets, popovers, full-screen covers, alerts, and confirmation dialogs are one shell's words for
one look. Naming them here would oblige every other execution context — a server rendering the
same state as a page, a browser rendering it as a region — to describe its own state in a client
framework's terms.

What survives the change of shell is the pair this package models: whether the presenting
destination stays interactive, and who is allowed to end the presentation. Only the second
constrains a runtime, and it constrains it materially — dismissal authority decides whether a
dismissal arriving without a program action is legal state or a defect. The choice between a sheet
and a full-screen cover is appearance, and a shell derives it from the destination value it is
already switching on.

### What lives elsewhere

The tree that composes stacks and presentations into whole navigation state, and the operations
that drive it, belong to the L3 twin. Turning a URL into navigation state, or navigation state
back into a URL, belongs to the consumer that owns both the destination type and its route
grammar — that composition needs the application's own destination type, which no library owns.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).
