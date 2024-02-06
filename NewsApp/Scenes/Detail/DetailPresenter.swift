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

    private var model: NewsData?

    // MARK: - Properties

    var nameText = String()

    var newsImage = UIImage(systemName: "photo")!

    var descriptionText = String()

    var isAddedToFavorites = false


    // MARK: - init

    init(view: DetailViewProtocol?, model: NewsData?) {
        self.view = view
        self.model = model
    }

    // MARK: - Private methods

    private func checkIsInFavorites() -> Bool {
        guard let model = model else { return false}
        return StorageManager.isAddedToFavorites(forKey: model.articleID)
    }

    private func downloadImage(completion: @escaping () -> Void) {
        guard let url = URL(string: model?.imageURL ?? "") else {
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
        guard let articleID = model?.articleID else { return }
        guard isAddedToFavorites else {
            StorageManager.removeValue(forKey: articleID)
            return
        }
        StorageManager.save(value: articleID, forKey: articleID)
    }

}

// MARK: - Presenter Protocol

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        isAddedToFavorites = checkIsInFavorites()
        nameText = model?.title ?? "Data is missing"
        descriptionText = model?.description ?? "Data is missing"
        downloadImage { [weak self] in
            self?.view?.didReceiveData()
        }
    }

    func didTapAddToFavorites(isSelected: Bool) {
        isAddedToFavorites = isSelected
    }
}
