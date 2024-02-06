//
//  NewsRouter.swift
//  NewsApp
//

import Foundation

protocol NewsRouterProtocol {
    /// Navigates to DetailViewController
    func routToDetail(model: NewsData)
}

final class NewsRouter {

    // MARK: - Dependencies

    private weak var view: NewsViewProtocol?

    // MARK: - init
    init(view: NewsViewProtocol) {
        self.view = view
    }
}

// MARK: - Router Protocol

extension NewsRouter: NewsRouterProtocol {
    /// Navigate to the detail screen.
    func routToDetail(model: NewsData) {
        let viewController = DetailAssembler.assembly(model: model)
        view?.pushViewController(viewController, animated: true)
    }
}
