//
//  NewsPresenter.swift
//  NewsApp
//

import Foundation

protocol NewsPresenterProtocol: BasePresenterProtocol {

    var news: [Result] { get }

    func segmentDidChange(selectedSegmentIndex: Int)

    /// Called when the monstersTableView row is tapped.
    func didSelectSettingsRow(item: Result)
}

final class NewsPresenter {

    // MARK: - Properties

    var news: [Result] = []

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
                self?.news = newsModel.results
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
    func didSelectSettingsRow(item: Result) {
        router.routToDetail(model: item)
    }
}

