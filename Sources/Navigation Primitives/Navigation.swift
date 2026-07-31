/// Namespace for the navigation-state algebra.
///
/// Navigation state answers one question: which destinations does a person
/// currently occupy, in what order, and how did each one come to be shown?
/// This namespace owns the vocabulary that question is asked in — placement,
/// ordering, and presentation — as pure values with no runtime attached.
///
/// ## Core concepts
///
/// - A **destination** is the consumer's own description of a place. This
///   package never inspects it and imposes no constraint on it.
/// - A **placement** pairs a destination with a ``Navigation/Identity``, so
///   two visits to the same destination are distinguishable.
/// - A **stack** is an ordered run of placements with unique identities.
/// - A **presentation** describes how one destination is shown over another,
///   in terms every execution context shares.
///
/// ## Example
///
/// ```swift
/// enum Screen { case home, settings, profile(String) }
///
/// var source = Navigation.Identity.Source()
/// var stack = Navigation.Stack<Screen>()
///
/// try stack.push(Navigation.Destination(identity: source.mint(), value: .settings))
/// try stack.push(Navigation.Destination(identity: source.mint(), value: .profile("ada")))
///
/// stack.top?.value        // .profile("ada")
/// stack.count             // 2
/// ```
///
/// ## What lives elsewhere
///
/// The tree that composes stacks and presentations into whole navigation
/// state, and the operations that drive it, belong to the L3 twin. Turning a
/// URL into navigation state, or navigation state back into a URL, belongs to
/// the consumer that owns both the destination type and its route grammar.
public enum Navigation {}
