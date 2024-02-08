//
//  NewsPresenter.swift
//  NewsApp
//

import Foundation

protocol NewsPresenterProtocol: BasePresenterProtocol {

    var newsData: [NewsData] { get }

    var news: [News] { get }

    var canPaginating: Bool { get }

    func segmentDidChange(selectedSegmentIndex: Int)

    func didStartPagination()

    /// Called when the newsTableView row is tapped.
    func didSelectNewsRow(item: News)
}

final class NewsPresenter {

    // MARK: - Properties

    var newsData: [NewsData] = []

    var news: [News] = []

    var nextPages: [String] = []

    var canPaginating = false

    // MARK: - Dependencies

    weak var view: NewsViewProtocol?

    private let networkService: NewsServiceProtocol

    private var router: NewsRouterProtocol

    // MARK: - init

    init(
        view: NewsViewProtocol?,
        networkService: NewsServiceProtocol,
        router: NewsRouterProtocol
    ) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
}

// MARK: - Presenter Protocol

extension NewsPresenter: NewsPresenterProtocol {
    func viewDidLoad() {
        networkService.getNews { [weak self] result in
            switch result {
            case .success(let newsModel):
                var uniqueNews = [News]()
                for newsData in newsModel.results {
                    let isUnique = !uniqueNews.contains { $0.title == newsData.title }
                    if isUnique {
                        let news = News(context: CoreDataManager.shared.viewContext)
                        news.newsID = newsData.articleID
                        news.creator = newsData.creator?.first
                        news.descriptionText = newsData.description
                        news.imageURL = newsData.imageURL
                        news.pubDate = newsData.pubDate
                        news.title = newsData.title
                        uniqueNews.append(news)
                    }
                }
                self?.news = uniqueNews
                self?.nextPages.append(newsModel.nextPage)
                self?.canPaginating = true
                self?.view?.didReceiveData()
            case .error(let error):
                print(error)
            }
        }
    }

    func segmentDidChange(selectedSegmentIndex: Int) {
        print(selectedSegmentIndex)
    }

    /// Called when the newsTableView row is tapped.
    func didSelectNewsRow(item: News) {
        router.routToDetail(model: item)
    }

    func didStartPagination() {
        guard let nextPage = nextPages.last else { return }
        canPaginating = false
        networkService.getNextNews(pageNumber: nextPage) { [weak self] result in
            switch result {
            case .success(let newsModel):
                var uniqueNews = [News]()
                for newsData in newsModel.results {
                    let isUnique = !uniqueNews.contains { $0.title == newsData.title }
                    if isUnique {
                        let news = News(context: CoreDataManager.shared.viewContext)
                        news.newsID = newsData.articleID
                        news.creator = newsData.creator?.first
                        news.descriptionText = newsData.description
                        news.imageURL = newsData.imageURL
                        news.pubDate = newsData.pubDate
                        news.title = newsData.title
                        uniqueNews.append(news)
                    }
                }
                self?.news.append(contentsOf: uniqueNews)
                self?.nextPages.append(newsModel.nextPage)
                self?.canPaginating = true
                self?.view?.didReceiveData()
            case .error(let error):
                print(error)
            }
        }
    }
}

