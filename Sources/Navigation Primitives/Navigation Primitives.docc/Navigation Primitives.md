# ``Navigation_Primitives``

@Metadata {
    @DisplayName("Navigation Primitives")
    @TitleHeading("Swift Primitives")
}

The navigation-state algebra: placement, ordering, and presentation as pure values.

## Overview

This package owns what it means for a destination to occupy a place in navigation state. A
placement pairs the consumer's own destination value with an identity, so two visits to the same
place stay distinguishable; a stack orders placements and enforces that their identities are
unique; a presentation says how one destination is shown over another in terms that survive a
change of execution context.

Nothing here runs. The tree that composes stacks and presentations into whole navigation state,
and the operations that drive it, belong to the L3 twin. Turning a URL into navigation state, or
navigation state back into a URL, belongs to the consumer that owns both the destination type and
its route grammar.

## Topics

### Placement

- ``Navigation/Destination``
- ``Navigation/Identity``

### Ordering

- ``Navigation/Stack``

### Presentation

- ``Navigation/Presentation``

### Failure

- ``Navigation/Error``
