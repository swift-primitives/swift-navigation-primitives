extension Navigation {

    public struct Stack<Value> {

        var placed: [Navigation.Destination<Value>]

        public init() {
            self.placed = []
        }
    }
}

extension Navigation.Stack {

    public init(
        _ destinations: some Swift.Sequence<Navigation.Destination<Value>>
    ) throws(Navigation.Error) {
        self.init()
        for destination in destinations {
            try push(destination)
        }
    }
}

extension Navigation.Stack {

    public var top: Navigation.Destination<Value>? {
        placed.last
    }

    public func contains(_ identity: Navigation.Identity) -> Bool {
        position(of: identity) != nil
    }

    public func destination(_ identity: Navigation.Identity) -> Navigation.Destination<Value>? {
        position(of: identity).map { placed[$0] }
    }

    func position(of identity: Navigation.Identity) -> Int? {
        placed.firstIndex { $0.identity == identity }
    }
}

extension Navigation.Stack {

    public mutating func push(
        _ destination: Navigation.Destination<Value>
    ) throws(Navigation.Error) {
        guard !contains(destination.identity) else {
            throw Navigation.Error.duplicate(destination.identity)
        }
        placed.append(destination)
    }

    public mutating func pop() -> Navigation.Destination<Value>? {
        placed.popLast()
    }

    public mutating func pop(to identity: Navigation.Identity) throws(Navigation.Error) {
        guard let position = position(of: identity) else {
            throw Navigation.Error.unknown(identity)
        }
        placed.removeSubrange(placed.index(after: position)...)
    }
}

extension Navigation.Stack: RandomAccessCollection {

    public typealias Element = Navigation.Destination<Value>

    public typealias Index = Int

    public var startIndex: Int { placed.startIndex }

    public var endIndex: Int { placed.endIndex }

    public subscript(position: Int) -> Navigation.Destination<Value> {
        placed[position]
    }
}

extension Navigation.Stack: Sendable where Value: Sendable {}
extension Navigation.Stack: Equatable where Value: Equatable {}
extension Navigation.Stack: Hashable where Value: Hashable {}
