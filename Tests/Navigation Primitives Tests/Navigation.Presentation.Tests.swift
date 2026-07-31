import Navigation_Primitives
import Testing

extension Navigation.Presentation {
    @Suite struct Test {
        @Suite struct Unit {}
    }
}

extension Navigation.Presentation.Test.Unit {
    @Test func `a presentation carries exactly a mode and a dismissal`() {
        let sheet = Navigation.Presentation(mode: .modal, dismissal: .user)

        #expect(sheet.mode == .modal)
        #expect(sheet.dismissal == .user)
    }

    @Test func `mode and dismissal vary independently`() {
        let combinations = Navigation.Presentation.Mode.allCases.flatMap { mode in
            Navigation.Presentation.Dismissal.allCases.map { dismissal in
                Navigation.Presentation(mode: mode, dismissal: dismissal)
            }
        }

        #expect(combinations.count == 4)
        #expect(Set(combinations).count == 4)
    }

    @Test func `presentations differing only in dismissal are not equal`() {
        let dismissible = Navigation.Presentation(mode: .modal, dismissal: .user)
        let insistent = Navigation.Presentation(mode: .modal, dismissal: .program)

        #expect(dismissible != insistent)
    }

    @Test func `the mode axis has exactly the two shell-independent cases`() {
        #expect(Navigation.Presentation.Mode.allCases == [.modal, .modeless])
    }

    @Test func `the dismissal axis has exactly the two authorities`() {
        #expect(Navigation.Presentation.Dismissal.allCases == [.user, .program])
    }

    @Test func `an occupied slot is reported against the mode that is taken`() {
        let occupied = Navigation.Error.occupied(.modal)

        #expect(occupied == .occupied(.modal))
        #expect(occupied != .occupied(.modeless))
    }
}
