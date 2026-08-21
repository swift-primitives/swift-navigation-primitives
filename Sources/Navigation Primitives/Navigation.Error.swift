extension Navigation {

    public enum Error: Swift.Error, Sendable, Hashable {

        case unknown(Navigation.Identity)

        case duplicate(Navigation.Identity)

        case occupied(Navigation.Presentation.Mode)
    }
}
