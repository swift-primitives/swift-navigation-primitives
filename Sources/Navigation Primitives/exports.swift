// `Navigation.Identity` is an instantiation of `Tagged`, so its underlying-value
// access and its conformances are declared by the owner. Re-exporting keeps a
// consumer that imports this module from needing a second import to read
// `identity.underlying`.
@_exported public import Tagged_Primitives
