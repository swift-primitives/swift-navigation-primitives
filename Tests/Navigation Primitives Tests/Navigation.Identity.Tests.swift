import Navigation_Primitives
import Testing

extension Navigation.Identity {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension Navigation.Identity.Test.Unit {
    @Test func `a fresh source mints from zero`() {
        var source = Navigation.Identity.Source()

        #expect(source.mint().ordinal == 0)
        #expect(source.mint().ordinal == 1)
        #expect(source.mint().ordinal == 2)
    }

    @Test func `next reports the identity mint will return`() {
        var source = Navigation.Identity.Source()
        _ = source.mint()

        let announced = source.next
        let minted = source.mint()

        #expect(announced == minted)
    }

    @Test func `minted identities are never equal to one another`() {
        var source = Navigation.Identity.Source()
        var seen: Set<Navigation.Identity> = []

        for _ in 0..<128 {
            let minted = source.mint()
            #expect(!seen.contains(minted))
            seen.insert(minted)
        }

        #expect(seen.count == 128)
    }

    @Test func `comparison reports mint order`() {
        var source = Navigation.Identity.Source()
        let earlier = source.mint()
        let later = source.mint()

        #expect(earlier < later)
        #expect(!(later < earlier))
        #expect(earlier != later)
    }

    @Test func `a source is a value, so copies mint independently`() {
        var original = Navigation.Identity.Source()
        _ = original.mint()

        var copy = original
        let fromCopy = copy.mint()
        let fromOriginal = original.mint()

        #expect(fromCopy == fromOriginal)
        #expect(copy == original)
    }

    @Test func `replaying the same placements reproduces the same identities`() {
        func run() -> [Navigation.Identity] {
            var source = Navigation.Identity.Source()
            return (0..<8).map { _ in source.mint() }
        }

        #expect(run() == run())
    }
}

extension Navigation.Identity.Test.`Edge Case` {
    @Test func `a restored source resumes from the recorded ordinal`() {
        var source = Navigation.Identity.Source(next: Navigation.Identity(ordinal: 41))

        #expect(source.mint().ordinal == 41)
        #expect(source.next.ordinal == 42)
    }

    @Test func `identities minted by different sources compare by ordinal alone`() {
        var left = Navigation.Identity.Source()
        var right = Navigation.Identity.Source()

        #expect(left.mint() == right.mint())
    }
}
