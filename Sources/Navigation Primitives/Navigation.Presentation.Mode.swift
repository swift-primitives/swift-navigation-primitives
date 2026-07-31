extension Navigation.Presentation {
    /// Whether the presenting destination stays interactive while the
    /// presentation stands.
    ///
    /// This is the classical modal/modeless distinction, and it is the part of
    /// "how something is shown" that means the same thing in every execution
    /// context. It is also the axis navigation state branches on: a destination
    /// may hold one presentation of each mode at once, which is what keeps
    /// navigation state a tree rather than a single chain.
    public enum Mode: Sendable, Hashable, CaseIterable {
        /// The presenting destination is inert while the presentation stands.
        ///
        /// The person must finish or leave the presented destination before the
        /// presenter accepts input again. Sheets, full-screen covers, alerts,
        /// and confirmation dialogs are all this mode on an Apple client; on a
        /// server the same state is a page the request must pass through.
        case modal

        /// The presenting destination stays live alongside the presentation.
        ///
        /// Both are usable at once, and input to the presenter does not first
        /// have to end the presentation. Popovers, inspectors, and side panels
        /// are this mode on an Apple client; on a server the same state is a
        /// region rendered beside the main content.
        case modeless
    }
}
