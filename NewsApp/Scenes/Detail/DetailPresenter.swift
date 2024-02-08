//
//  DetailPresenter.swift
//  NewsApp
//

import UIKit
import Kingfisher

protocol DetailPresenterProtocol: BasePresenterProtocol {

    var nameText: String { get }
    var newsImage: UIImage { get }
    var descriptionText: String { get }
    var isAddedToFavorites: Bool { get }

    func didTapAddToFavorites(isSelected: Bool)
}

final class DetailPresenter {

    // MARK: - Dependencies

    private weak var view: DetailViewProtocol?

    private var model: News

    // MARK: - Properties

    var nameText = String()

    var newsImage = UIImage(systemName: "photo")!

    var descriptionText = String()

    var isAddedToFavorites = false

    private let storageManager = CoreDataManager.shared

    private var favoriteNews: [News] = []

    private var	 currentNews: News?


    // MARK: - init

    init(view: DetailViewProtocol?, model: News) {
        self.view = view
        self.model = model
    }

    // MARK: - Private methods

    private func checkIsInFavorites() -> Bool {
        guard let id = model.newsID else { return false }
        return StorageManager.isAddedToFavorites(forKey: id)
    }

    private func downloadImage(completion: @escaping () -> Void) {
        guard let url = URL(string: model.imageURL ?? "") else {
            completion()
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)

        KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor)]) { [weak self] result in
            switch result {
            case .success(let data):
                self?.newsImage = data.image
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }

    // MARK: - deinit
    deinit {
        guard let id = model.newsID else { return }
        guard isAddedToFavorites else {
            StorageManager.removeValue(forKey: id)
            return
        }
        StorageManager.save(value: id, forKey: id)
    }

}

// MARK: - Presenter Protocol

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        isAddedToFavorites = checkIsInFavorites()
        nameText = model.title ?? "Data is missing"
        descriptionText = model.descriptionText ?? "Data is missing"
        downloadImage { [weak self] in
            self?.view?.didReceiveData()
        }
    }

    func didTapAddToFavorites(isSelected: Bool) {
        isAddedToFavorites = isSelected
        if isSelected {
            storageManager.saveNews(newsData: model) {
                print("succesful save")
            }
        } else {
            storageManager.delete(news: model) {
                print("succesful delete")
            }

//            storageManager.loadNews { result in
//                switch result {
//                case .success(let news):
//                    favoriteNews = news
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            for news in favoriteNews {
//                if news.newsID == model.newsID {
//                    currentNews = news
//                }
//            }
//            guard let news = currentNews else { return }
//            storageManager.delete(news: news) {
//                print("succesful delete")
//            }
        }
    }
}
