//
//  FavoritesPresenter.swift
//  NewsApp
//

import Foundation

protocol FavoritesPresenterProtocol: BasePresenterProtocol {

    var newsArray: [NewsData] { get }

    /// Called when the favoritesTableView row is tapped.
    func didSelectFavoritesRow(item: NewsData)

    func didDeleteRow(index: Int)
}

final class FavoritesPresenter {

    // MARK: - Properties

    var newsArray: [NewsData] = []

    let storageManager = CoreDataManager.shared

    // MARK: - Dependencies

    private weak var view: FavoritesViewProtocol?

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
                newsArray.removeAll()
                for article in newsData {
                   let news = NewsData(
                    articleID: article.newsID ?? String.Favorites.dataIsMissing,
                    title: article.title ?? String.Favorites.dataIsMissing,
                    creator: [article.creator ?? String.Favorites.dataIsMissing],
                    description: article.descriptionText,
                    pubDate: article.pubDate ?? String.Favorites.dataIsMissing,
                    imageURL: article.imageURL,
                    sourceURL: article.sourceURL
                   )
                    newsArray.append(news)
                }
                view?.didReceiveData()
            case .failure(let error):
                print(error)
            }
        }
    }

    /// Called when the favoritesTableView row is tapped.
    func didSelectFavoritesRow(item: NewsData) {
        router.routToDetail(model: item)
    }

    func didDeleteRow(index: Int) {
        let currnentNews = newsArray[index]
        storageManager.delete(newsData: currnentNews) {
            UserDefaultsManager.removeValue(forKey: newsArray[index].articleID)
            newsArray.remove(at: index)
            view?.didReceiveData()
        }
    }
}

