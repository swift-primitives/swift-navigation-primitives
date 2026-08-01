import Navigation_Primitives
import Testing

/// `Navigation.Identity` is a `Tagged` instantiation, and a suite cannot be nested in a
/// constrained extension of a generic type, so the suite is hosted top-level per the
/// testing skill.
@Suite struct `Navigation Identity Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Navigation Identity Tests`.Unit {
    @Test func `a fresh source mints from zero`() {
        var source = Navigation.Source()

        #expect(source.mint().underlying == 0)
        #expect(source.mint().underlying == 1)
        #expect(source.mint().underlying == 2)
    }

    @Test func `next reports the identity mint will return`() {
        var source = Navigation.Source()
        _ = source.mint()

        let announced = source.next
        let minted = source.mint()

        #expect(announced == minted)
    }

    @Test func `minted identities are never equal to one another`() {
        var source = Navigation.Source()
        var seen: Set<Navigation.Identity> = []

        for _ in 0..<128 {
            let minted = source.mint()
            #expect(!seen.contains(minted))
            seen.insert(minted)
        }

        #expect(seen.count == 128)
    }

    @Test func `comparison reports mint order`() {
        var source = Navigation.Source()
        let earlier = source.mint()
        let later = source.mint()

        #expect(earlier < later)
        #expect(!(later < earlier))
        #expect(earlier != later)
    }

    @Test func `a source is a value, so copies mint independently`() {
        var original = Navigation.Source()
        _ = original.mint()

        var copy = original
        let fromCopy = copy.mint()
        let fromOriginal = original.mint()

        #expect(fromCopy == fromOriginal)
        #expect(copy == original)
    }

    @Test func `replaying the same placements reproduces the same identities`() {
        func run() -> [Navigation.Identity] {
            var source = Navigation.Source()
            return (0..<8).map { _ in source.mint() }
        }

        #expect(run() == run())
    }
}

extension `Navigation Identity Tests`.`Edge Case` {
    @Test func `a restored source resumes from the recorded ordinal`() {
        var source = Navigation.Source(next: Navigation.Identity(41))

        #expect(source.mint().underlying == 41)
        #expect(source.next.underlying == 42)
    }

    @Test func `identities minted by different sources compare by ordinal alone`() {
        var left = Navigation.Source()
        var right = Navigation.Source()

        #expect(left.mint() == right.mint())
    }
}
