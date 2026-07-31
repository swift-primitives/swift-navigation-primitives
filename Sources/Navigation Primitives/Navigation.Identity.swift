public import Tagged_Primitives

extension Navigation {
    /// Distinguishes one placement of a destination from every other placement.
    ///
    /// Navigation state has to tell two visits to the same place apart. Pushing
    /// `.profile("ada")` twice produces two placements that compare equal by
    /// value and must still be popped independently, and a request to return to
    /// "the first one" has to mean something. An identity is what makes that
    /// well defined: it names the *occurrence*, never the destination.
    ///
    /// Identities are minted by ``Navigation/Source``, in strictly increasing
    /// order, and are never reused within a source. Comparison therefore reports
    /// mint order — an identity that sorts lower was placed earlier — and a
    /// reference held past a pop can never silently alias a destination placed
    /// later.
    ///
    /// ```swift
    /// var source = Navigation.Source()
    /// let first = source.mint()
    /// let second = source.mint()
    /// first < second      // true
    /// first == second     // false
    /// ```
    ///
    /// ## Why this is a `Tagged`, and not a struct of its own
    ///
    /// An identity is a phantom-typed wrapper over a `UInt64`, and
    /// `swift-tagged-primitives` owns that capability. `Tagged` supplies the
    /// zero-overhead wrapper, public construction and public read of the
    /// underlying value, and conditional `Sendable`, `Hashable`, `Comparable`,
    /// and `BitwiseCopyable` — every conformance an identity needs, each
    /// satisfied by `UInt64`. A local struct would have differed from this
    /// instantiation only by spelling.
    ///
    /// The phantom tag is the ``Navigation`` namespace itself, per the naming
    /// doctrine that the surrounding namespace enum *is* the phantom.
    ///
    /// The underlying value is readable so navigation state can be written down
    /// and read back. It carries no meaning of its own: an identity is
    /// interpretable only against the source that minted it, and identities from
    /// two different sources are not comparable in any useful sense even though
    /// the compiler will happily compare them.
    ///
    /// Construct one directly only when restoring recorded state —
    /// `Navigation.Identity(41)`. To place a new destination, mint from a
    /// ``Navigation/Source``: minting by hand risks colliding with an identity
    /// the source will later produce, which the stack rejects as
    /// ``Navigation/Error/duplicate(_:)``.
    public typealias Identity = Tagged<Navigation, UInt64>
}
