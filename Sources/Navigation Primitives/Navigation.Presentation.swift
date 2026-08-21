extension Navigation {

    public struct Presentation: Sendable, Hashable {

        public var mode: Navigation.Presentation.Mode

        public var dismissal: Navigation.Presentation.Dismissal

        public init(
            mode: Navigation.Presentation.Mode,
            dismissal: Navigation.Presentation.Dismissal
        ) {
            self.mode = mode
            self.dismissal = dismissal
        }
    }
}
