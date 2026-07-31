extension Navigation {
    /// An ordered run of placements, bottom first.
    ///
    /// A stack is what "drilling in" produces: each push adds a placement above
    /// the last, each pop removes the topmost, and a return to an earlier place
    /// discards everything above it. The one invariant the type enforces is that
    /// identities are unique within the stack — without it, ``pop(to:)`` would
    /// have to guess which occurrence was meant.
    ///
    /// ```swift
    /// var source = Navigation.Source()
    /// var stack = Navigation.Stack<Screen>()
    ///
    /// let list = Navigation.Destination(identity: source.mint(), value: Screen.list)
    /// try stack.push(list)
    /// try stack.push(Navigation.Destination(identity: source.mint(), value: .detail))
    /// try stack.push(Navigation.Destination(identity: source.mint(), value: .edit))
    ///
    /// try stack.pop(to: list.identity)
    /// stack.count             // 1
    /// stack.top?.value        // .list
    /// ```
    ///
    /// The stack is a `RandomAccessCollection` over its placements, so a shell
    /// renders it by iterating rather than by reaching past the type for its
    /// storage. It is a value throughout: copies are independent, equality is
    /// structural, and there is no runtime behind it.
    public struct Stack<Value> {
        /// Placements from the bottom of the stack to the top.
        var placed: [Navigation.Destination<Value>]

        /// Creates a stack holding nothing.
        public init() {
            self.placed = []
        }
    }
}

// MARK: - Construction

extension Navigation.Stack {
    /// Creates a stack holding `destinations`, bottom first.
    ///
    /// Building a stack in one step is what a deep-link parser wants: it knows
    /// the whole run before any of it is shown.
    ///
    /// - Parameter destinations: Placements in bottom-to-top order.
    /// - Throws: ``Navigation/Error/duplicate(_:)`` when two placements share an
    ///   identity.
    public init(
        _ destinations: some Sequence<Navigation.Destination<Value>>
    ) throws(Navigation.Error) {
        self.init()
        for destination in destinations {
            try push(destination)
        }
    }
}

// MARK: - Inspection

extension Navigation.Stack {
    /// The topmost placement, or `nil` when the stack holds nothing.
    public var top: Navigation.Destination<Value>? {
        placed.last
    }

    /// Reports whether `identity` names a placement on this stack.
    ///
    /// - Parameter identity: The identity to look for.
    /// - Returns: `true` when a placement on this stack carries `identity`.
    public func contains(_ identity: Navigation.Identity) -> Bool {
        position(of: identity) != nil
    }

    /// The placement carrying `identity`, or `nil` when there is none.
    ///
    /// - Parameter identity: The identity to look for.
    /// - Returns: The matching placement.
    public func destination(_ identity: Navigation.Identity) -> Navigation.Destination<Value>? {
        position(of: identity).map { placed[$0] }
    }

    /// The offset of the placement carrying `identity`, counting from the bottom.
    func position(of identity: Navigation.Identity) -> Int? {
        placed.firstIndex { $0.identity == identity }
    }
}

// MARK: - Mutation

extension Navigation.Stack {
    /// Places `destination` above everything already on the stack.
    ///
    /// - Parameter destination: The placement to add.
    /// - Throws: ``Navigation/Error/duplicate(_:)`` when the stack already holds
    ///   a placement with the same identity. Minting each placement from the
    ///   state's own ``Navigation/Source`` makes that unreachable.
    public mutating func push(
        _ destination: Navigation.Destination<Value>
    ) throws(Navigation.Error) {
        guard !contains(destination.identity) else {
            throw Navigation.Error.duplicate(destination.identity)
        }
        placed.append(destination)
    }

    /// Removes and returns the topmost placement.
    ///
    /// - Returns: The placement removed, or `nil` when the stack held nothing.
    public mutating func pop() -> Navigation.Destination<Value>? {
        placed.popLast()
    }

    /// Removes placements from the top until `identity` is topmost.
    ///
    /// Returning to a place the person has already seen is one operation, not a
    /// loop of pops, and it is total: either `identity` is on the stack and
    /// becomes the top, or nothing is removed and the call throws. Popping to
    /// the placement that is already topmost removes nothing and succeeds.
    ///
    /// - Parameter identity: The placement to return to.
    /// - Throws: ``Navigation/Error/unknown(_:)`` when no placement on this
    ///   stack carries `identity`; the stack is left untouched.
    public mutating func pop(to identity: Navigation.Identity) throws(Navigation.Error) {
        guard let position = position(of: identity) else {
            throw Navigation.Error.unknown(identity)
        }
        placed.removeSubrange(placed.index(after: position)...)
    }
}

// MARK: - Collection

extension Navigation.Stack: RandomAccessCollection {
    /// A placement on the stack.
    public typealias Element = Navigation.Destination<Value>

    /// An offset from the bottom of the stack.
    public typealias Index = Int

    /// The offset of the bottom placement.
    public var startIndex: Int { placed.startIndex }

    /// The offset one past the topmost placement.
    public var endIndex: Int { placed.endIndex }

    /// The placement at `position`, counting from the bottom.
    ///
    /// - Parameter position: An offset in `startIndex..<endIndex`.
    public subscript(position: Int) -> Navigation.Destination<Value> {
        placed[position]
    }
}

// MARK: - Conditional Conformances

extension Navigation.Stack: Sendable where Value: Sendable {}
extension Navigation.Stack: Equatable where Value: Equatable {}
extension Navigation.Stack: Hashable where Value: Hashable {}
