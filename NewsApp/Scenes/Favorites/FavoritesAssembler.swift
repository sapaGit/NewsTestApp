//
//  FavoritesAssembler.swift
//  NewsApp
//

final class FavoritesAssembler {

    /// Assembly the components for the news screen.
    ///
    /// - Returns: An instance of `FavoritesViewController` configured with its associated presenter and router.
    class func assembly() -> FavoritesViewController {
        let view = FavoritesViewController()
        let router = FavoritesRouter(view: view)
        let presenter = FavoritesPresenter(
            view: view,
            router: router)

        view.presenter = presenter

        return view
    }
}
