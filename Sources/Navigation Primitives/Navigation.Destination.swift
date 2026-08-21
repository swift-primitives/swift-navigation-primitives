extension Navigation {

    public struct Destination<Value> {

        public let identity: Navigation.Identity

        public var value: Value

        public init(identity: Navigation.Identity, value: Value) {
            self.identity = identity
            self.value = value
        }
    }
}

extension Navigation.Destination: Sendable where Value: Sendable {}
extension Navigation.Destination: Equatable where Value: Equatable {}
extension Navigation.Destination: Hashable where Value: Hashable {}
