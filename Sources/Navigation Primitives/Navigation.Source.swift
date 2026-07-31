public import Tagged_Primitives

extension Navigation {
    /// Mints identities in strictly increasing order.
    ///
    /// A source is a value, not a service. It is stored alongside the
    /// navigation state it mints for, copied with it, and compared with it,
    /// which is what makes navigation state reproducible: a source created by
    /// ``init()`` always starts at zero, so replaying the same sequence of
    /// placements produces bit-identical state, and two states that should be
    /// equal are equal.
    ///
    /// ```swift
    /// var source = Navigation.Source()
    /// source.mint().underlying   // 0
    /// source.mint().underlying   // 1
    /// source.next.underlying     // 2
    /// ```
    ///
    /// Nothing is recycled. A source never re-issues an ordinal it has already
    /// handed out, so an identity captured before a pop stays distinguishable
    /// from every identity minted afterwards rather than aliasing one of them.
    ///
    /// ## Why this is not part of ``Navigation/Identity``
    ///
    /// Minting is generation, not identity: a source owns a monotonic frontier
    /// and the guarantee that it never goes backwards, which is state that an
    /// identity — a single immutable value — does not have and should not carry.
    /// It is a sibling of `Identity` rather than a member of it also because
    /// `Identity` is an instantiation of an owner's generic type, and nesting a
    /// type inside it would either require a constrained extension, which Swift
    /// forbids nested types in, or an unconstrained one, which would add the
    /// member to every `Tagged` in the ecosystem.
    public struct Source: Sendable, Hashable {
        /// The identity the next call to ``mint()`` will return.
        public private(set) var next: Navigation.Identity

        /// Creates a source that will mint `next` first.
        ///
        /// Reserved for restoring recorded navigation state; use ``init()`` to
        /// begin a fresh sequence. Restoring a source below an identity already
        /// present in the accompanying state re-issues that identity, which the
        /// stack rejects as ``Navigation/Error/duplicate(_:)`` rather than
        /// accepting silently.
        ///
        /// - Parameter next: The first identity this source will mint.
        public init(next: Navigation.Identity) {
            self.next = next
        }
    }
}

// MARK: - Minting

extension Navigation.Source {
    /// Creates a source that mints from zero.
    public init() {
        self.init(next: Navigation.Identity(0))
    }

    /// Returns the next identity and advances the source past it.
    ///
    /// Traps on overflow, at which point the source has minted every value a
    /// `UInt64` can hold. That is a bound no navigation state reaches; it is
    /// left as a trap rather than a thrown error so that mint sites stay total.
    ///
    /// - Returns: An identity strictly greater than every identity this source
    ///   has minted before.
    public mutating func mint() -> Navigation.Identity {
        let minted = next
        next = Navigation.Identity(minted.underlying + 1)
        return minted
    }
}
