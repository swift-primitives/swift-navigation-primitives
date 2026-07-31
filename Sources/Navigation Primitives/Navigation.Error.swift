extension Navigation {
    /// A placement operation that could not be carried out.
    ///
    /// Every case describes a placement that cannot stand: an identity that
    /// names nothing, an identity that would name two things, or a presentation
    /// slot that is already taken. The vocabulary is otherwise total, and every
    /// throwing operation leaves its receiver untouched when it throws.
    ///
    /// The type is hosted on the non-generic ``Navigation`` namespace rather
    /// than nested in the generic types that throw it, so no error type is
    /// accidentally generic in a destination value it never mentions.
    public enum Error: Swift.Error, Sendable, Hashable {
        /// No placement carries this identity.
        ///
        /// Reached by returning to a destination that has already been popped,
        /// or by using an identity minted for different state.
        case unknown(Navigation.Identity)

        /// A placement already carries this identity.
        ///
        /// Reached by placing an identity twice — by reusing a value already in
        /// the state, or by restoring a ``Navigation/Source`` below an
        /// identity the accompanying state already holds. Minting each
        /// placement from the state's own source makes this unreachable.
        case duplicate(Navigation.Identity)

        /// A destination is already presented in this mode.
        ///
        /// Reached by presenting over a destination that is already presenting
        /// something of the same mode. Replacing it silently would discard
        /// whatever state hung below it, so the operation refuses instead: the
        /// caller either dismisses the standing presentation first, or presents
        /// from the destination that is already presented.
        case occupied(Navigation.Presentation.Mode)
    }
}
