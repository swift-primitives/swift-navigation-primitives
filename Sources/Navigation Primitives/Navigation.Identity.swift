extension Navigation {
    /// Distinguishes one placement of a destination from every other placement.
    ///
    /// Navigation state has to tell two visits to the same place apart. Pushing
    /// `.profile("ada")` twice produces two placements that compare equal by
    /// value and must still be popped independently, and a request to return to
    /// "the first one" has to mean something. An identity is what makes that
    /// well defined: it names the *occurrence*, never the destination.
    ///
    /// Identities are minted by ``Navigation/Identity/Source``, in strictly
    /// increasing order, and are never reused within a source. Comparison
    /// therefore reports mint order — an identity that sorts lower was placed
    /// earlier — and a reference held past a pop can never silently alias a
    /// destination placed later.
    ///
    /// ```swift
    /// var source = Navigation.Identity.Source()
    /// let first = source.mint()
    /// let second = source.mint()
    /// first < second      // true
    /// first == second     // false
    /// ```
    ///
    /// The ordinal is public so navigation state can be written down and read
    /// back. It carries no meaning of its own: an identity is interpretable
    /// only against the source that minted it, and identities from two
    /// different sources are not comparable in any useful sense even though
    /// the compiler will happily compare them.
    public struct Identity: Sendable, Hashable {
        /// The mint order of this identity within its source, counting from zero.
        public let ordinal: UInt64

        /// Creates an identity with an explicit mint order.
        ///
        /// Reserved for restoring recorded navigation state. To place a new
        /// destination, mint from a ``Navigation/Identity/Source`` instead:
        /// minting by hand risks colliding with an identity the source will
        /// later produce, which the stack rejects as
        /// ``Navigation/Error/duplicate(_:)``.
        ///
        /// - Parameter ordinal: The mint order to record.
        public init(ordinal: UInt64) {
            self.ordinal = ordinal
        }
    }
}

// MARK: - Comparison

extension Navigation.Identity: Comparable {
    /// Reports whether `lhs` was minted before `rhs`.
    ///
    /// - Parameters:
    ///   - lhs: An identity.
    ///   - rhs: An identity minted by the same source.
    /// - Returns: `true` when `lhs` has the lower mint order.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.ordinal < rhs.ordinal
    }
}
