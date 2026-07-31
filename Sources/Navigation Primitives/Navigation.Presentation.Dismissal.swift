extension Navigation.Presentation {
    /// Who may end a presentation.
    ///
    /// This is the half of a presentation that constrains a runtime. A
    /// presentation the person can end directly will be ended without any
    /// program action having asked for it, so the state has to treat an
    /// unsolicited dismissal as legal and reconcile to it. A presentation only
    /// the program ends has no such arrival, and one showing up is a defect
    /// worth surfacing rather than absorbing.
    public enum Dismissal: Sendable, Hashable, CaseIterable {
        /// The person may end the presentation directly.
        ///
        /// Swiping a sheet down, tapping outside a popover, or pressing Escape
        /// all end the presentation without asking the program first. State
        /// carrying this dismissal must accept that arrival.
        case user

        /// Only a program action ends the presentation.
        ///
        /// The presented destination stands until something in the program
        /// dismisses it — a migration that must run to completion, a decision
        /// that must be recorded. A dismissal arriving from anywhere else
        /// contradicts the state rather than updating it.
        case program
    }
}
