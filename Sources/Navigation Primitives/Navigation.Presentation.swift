extension Navigation {
    /// How one destination is shown over another.
    ///
    /// A presentation says two things, and deliberately no more: whether the
    /// presenting destination stays interactive while the presentation stands
    /// (``Navigation/Presentation/Mode``), and who is allowed to end it
    /// (``Navigation/Presentation/Dismissal``).
    ///
    /// ```swift
    /// let sheet = Navigation.Presentation(mode: .modal, dismissal: .user)
    /// let inspector = Navigation.Presentation(mode: .modeless, dismissal: .user)
    /// let migration = Navigation.Presentation(mode: .modal, dismissal: .program)
    /// ```
    ///
    /// ## Why there is no widget vocabulary here
    ///
    /// Sheets, popovers, full-screen covers, alerts, and confirmation dialogs
    /// are a particular shell's words for a particular look. Naming them here
    /// would oblige every other execution context — a server rendering the same
    /// state as a page, a browser rendering it as a region — to describe its own
    /// state in a client framework's terms.
    ///
    /// What survives the change of shell is the pair above. Only the second
    /// half constrains a runtime, and it constrains it materially: dismissal
    /// authority is what decides whether a dismissal arriving without a program
    /// action is legal state or a defect. Choosing between a sheet and a
    /// full-screen cover is appearance, and a shell derives it from the
    /// destination value it is already switching on.
    public struct Presentation: Sendable, Hashable {
        /// Whether the presenting destination stays interactive.
        public var mode: Navigation.Presentation.Mode

        /// Who may end the presentation.
        public var dismissal: Navigation.Presentation.Dismissal

        /// Describes a presentation.
        ///
        /// Both halves are required. Neither has a defensible default: a mode
        /// chosen for the caller would decide whether the presenter keeps
        /// working, and a dismissal chosen for the caller would decide whether
        /// unsolicited dismissals are legal.
        ///
        /// - Parameters:
        ///   - mode: Whether the presenting destination stays interactive.
        ///   - dismissal: Who may end the presentation.
        public init(
            mode: Navigation.Presentation.Mode,
            dismissal: Navigation.Presentation.Dismissal
        ) {
            self.mode = mode
            self.dismissal = dismissal
        }
    }
}
