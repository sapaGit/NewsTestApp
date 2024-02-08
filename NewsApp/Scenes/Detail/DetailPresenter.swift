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

    private var model: NewsData

    // MARK: - Properties

    var nameText = String()

    var newsImage = UIImage(systemName: "photo")!

    var descriptionText = String()

    var isAddedToFavorites = false

    private let storageManager = CoreDataManager.shared

    private var favoriteNews: [News] = []

    private var	 currentNews: News?


    // MARK: - init

    init(view: DetailViewProtocol?, model: NewsData) {
        self.view = view
        self.model = model
    }

    // MARK: - Private methods

    private func checkIsInFavorites() -> Bool {
        return UserDefaultsManager.isAddedToFavorites(forKey: model.articleID)
    }

    private func downloadImage(completion: @escaping () -> Void) {
        guard let imageURL = model.imageURL else { return }
        guard let url = URL(string: imageURL) else {
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
        guard isAddedToFavorites else {
            UserDefaultsManager.removeValue(forKey: model.articleID)
            return
        }
        UserDefaultsManager.save(value: model.articleID, forKey: model.articleID)
    }

}

// MARK: - Presenter Protocol

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        nameText = model.title
        descriptionText = model.description ?? "Data is missing"
        downloadImage { [weak self] in
            self?.view?.didReceiveData()
        }
    }

    func viewWillAppear() {
        isAddedToFavorites = checkIsInFavorites()
        view?.updateFavoritesButton()
    }

    func didTapAddToFavorites(isSelected: Bool) {
        isAddedToFavorites = isSelected
        if isSelected {
            storageManager.saveNews(newsData: model) {
                print("succesful save")
            }
        } else {
            storageManager.loadNews { result in
                switch result {
                case .success(let news):
                    for article in news {
                        if article.newsID == model.articleID {
                            storageManager.delete(news: article) {
                                print("succesful delete")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
