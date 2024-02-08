//
//  FavoritesPresenter.swift
//  NewsApp
//

import Foundation

protocol FavoritesPresenterProtocol: BasePresenterProtocol {

    var news: [News] { get }

    /// Called when the favoritesTableView row is tapped.
    func didSelectFavoritesRow(item: News)
}

final class FavoritesPresenter {

    // MARK: - Properties

    var news: [News] = []

    let storageManager = CoreDataManager.shared

    // MARK: - Dependencies

    weak var view: FavoritesViewProtocol?

    private var router: FavoritesRouterProtocol

    // MARK: - init

    init(
        view: FavoritesViewProtocol?,
        router: FavoritesRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - Presenter Protocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    func viewWillAppear() {
        storageManager.loadNews { result in
            switch result {
            case .success(let newsData):
                self.news = newsData
                view?.didReceiveData()
            case .failure(let error):
                print(error)
            }
        }
    }

    /// Called when the favoritesTableView row is tapped.
    func didSelectFavoritesRow(item: News) {
        router.routToDetail(model: item)
    }

}

