//
//  DetailPresenter.swift
//  NewsApp
//

import UIKit
import Kingfisher

protocol DetailPresenterProtocol: BasePresenterProtocol {

    var creatorText: String? { get }
    var nameText: String { get }
    var newsImage: UIImage { get }
    var descriptionText: String? { get }
    var sourceText: String? { get }
    var isAddedToFavorites: Bool { get }

    func didTapAddToFavorites(isSelected: Bool)
}

final class DetailPresenter {

    // MARK: - Dependencies

    private weak var view: DetailViewProtocol?

    private var model: NewsData

    // MARK: - Properties

    var creatorText: String?

    var nameText = String()

    var newsImage = UIImage(systemName: "photo")!

    var descriptionText: String?

    var sourceText: String?

    var isAddedToFavorites = false

    private let storageManager = CoreDataManager.shared


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

        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
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
}

// MARK: - Presenter Protocol

extension DetailPresenter: DetailPresenterProtocol {
    
    func viewDidLoad() {
        creatorText = model.creator?.first
        nameText = model.title ?? ""
        descriptionText = model.description
        downloadImage { [weak self] in
            self?.view?.updateImage()
        }
        sourceText = model.sourceURL
        view?.didReceiveData()
    }

    func viewWillAppear() {
        isAddedToFavorites = checkIsInFavorites()
        view?.updateFavoritesButton()
    }

    func didTapAddToFavorites(isSelected: Bool) {
        isAddedToFavorites = isSelected
        if isSelected {
            storageManager.saveNews(newsData: model) {
                UserDefaultsManager.save(value: model.articleID, forKey: model.articleID)
            }
        } else {
            storageManager.delete(newsData: model) {
                UserDefaultsManager.removeValue(forKey: model.articleID)
            }
        }
    }
}
