public import Tagged_Primitives

extension Navigation {

    public struct Source: Sendable, Hashable {

        public private(set) var next: Navigation.Identity

        public init(next: Navigation.Identity) {
            self.next = next
        }
    }
}

extension Navigation.Source {

    public init() {
        self.init(next: Navigation.Identity(0))
    }

    public mutating func mint() -> Navigation.Identity {
        let minted = next
        next = Navigation.Identity(minted.underlying + 1)
        return minted
    }
}
