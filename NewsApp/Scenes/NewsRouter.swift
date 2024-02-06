//
//  NewsRouter.swift
//  NewsApp
//

import Foundation

protocol NewsRouterProtocol {
    /// Navigates to DetailViewController
    func routToDetail(model: Result)
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
    func routToDetail(model: Result) {
        let viewController = DetailViewController()
        view?.pushViewController(viewController, animated: true)
    }
}
