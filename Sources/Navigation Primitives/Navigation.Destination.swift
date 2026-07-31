extension Navigation {
    /// One placed destination: where a person is, and which visit this is.
    ///
    /// `Value` is the consumer's own description of a place — an enum of
    /// screens, a route case, a record identifier. This package never inspects
    /// it and constrains it not at all; conformances are conditional, so a
    /// destination is `Equatable` exactly when its value is.
    ///
    /// ```swift
    /// enum Screen { case home, settings }
    ///
    /// var source = Navigation.Identity.Source()
    /// let settings = Navigation.Destination(identity: source.mint(), value: Screen.settings)
    /// let again = Navigation.Destination(identity: source.mint(), value: Screen.settings)
    ///
    /// settings.value == again.value           // true — the same place
    /// settings.identity == again.identity     // false — a different visit
    /// ```
    ///
    /// The identity is `let` and the value is `var`: a placement may be
    /// retargeted in place — a detail screen reloading with a different record
    /// — without becoming a different placement, which is what keeps a pending
    /// return to it meaningful.
    public struct Destination<Value> {
        /// Distinguishes this placement from every other placement.
        public let identity: Navigation.Identity

        /// The consumer's description of the place occupied.
        public var value: Value

        /// Places `value` under `identity`.
        ///
        /// - Parameters:
        ///   - identity: An identity minted by the source that owns the state
        ///     this placement will join.
        ///   - value: The consumer's description of the place.
        public init(identity: Navigation.Identity, value: Value) {
            self.identity = identity
            self.value = value
        }
    }
}

// MARK: - Conditional Conformances

extension Navigation.Destination: Sendable where Value: Sendable {}
extension Navigation.Destination: Equatable where Value: Equatable {}
extension Navigation.Destination: Hashable where Value: Hashable {}
