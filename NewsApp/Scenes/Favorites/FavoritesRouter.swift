//
//  FavoritesRouter.swift
//  NewsApp
//

import Foundation

protocol FavoritesRouterProtocol {
    /// Navigates to DetailViewController
    func routToDetail(model: NewsData)
}

final class FavoritesRouter {

    // MARK: - Dependencies

    private weak var view: FavoritesViewProtocol?

    // MARK: - init
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
}

// MARK: - Router Protocol

extension FavoritesRouter: FavoritesRouterProtocol {
    /// Navigate to the detail screen.
    func routToDetail(model: NewsData) {
        let viewController = DetailAssembler.assembly(model: model)
        view?.pushViewController(viewController, animated: true)
    }
}
