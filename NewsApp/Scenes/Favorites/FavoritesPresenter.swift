//
//  FavoritesPresenter.swift
//  NewsApp
//

import Foundation

protocol FavoritesPresenterProtocol: BasePresenterProtocol {

    var news: [News] { get }

    var newsDataArray: [NewsData] { get }

    /// Called when the favoritesTableView row is tapped.
    func didSelectFavoritesRow(item: NewsData)

    func didDeleteRow(index: Int)
}

final class FavoritesPresenter {

    // MARK: - Properties

    var news: [News] = []

    var newsDataArray: [NewsData] = []

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
                newsDataArray = []
                news = []
                for article in newsData {
                    news = newsData
                   let news = NewsData(
                    articleID: article.newsID ?? "Data is missing",
                    title: article.title ?? "Data is missing",
                    creator: [article.creator ?? "Data is missing"],
                    description: article.descriptionText,
                    pubDate: article.pubDate ?? "Data is missing",
                    imageURL: article.imageURL
                   )
                    newsDataArray.append(news)
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
        let currnentNews = news[index]
        storageManager.delete(news: currnentNews) {
            UserDefaultsManager.removeValue(forKey: newsDataArray[index].articleID)
            news.remove(at: index)
            newsDataArray.remove(at: index)
            view?.didReceiveData()
        }
    }

}

