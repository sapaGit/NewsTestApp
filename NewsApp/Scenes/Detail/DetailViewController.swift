//
//  DetailViewController.swift
//  NewsApp
//


import UIKit
import SnapKit
import Kingfisher

private enum Constants {
    static let topPadding: CGFloat = 20.0
    static let logoutButtonWidth: CGFloat = 100.0
    static let logoutButtonHeight: CGFloat = 44.0
    static let logoutCornerRadius: CGFloat = 10.0
}

protocol DetailViewProtocol: BaseViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData()
}

final class DetailViewController: BaseViewController {

    // MARK: - Properties

    var presenter: DetailPresenterProtocol!

    private let scrollView = UIScrollView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .center

        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private lazy var favoritesBarButton: UIBarButtonItem = {

        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoritesDidTap))

        return barButton
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    func configure() {

        nameLabel.text = presenter.nameText
        newsImageView.image = presenter.newsImage
        descriptionLabel.text = presenter.descriptionText
        favoritesBarButton.isSelected = presenter.isAddedToFavorites

    }

    // MARK: - Actions

    @objc
    private func favoritesDidTap() {
        favoritesBarButton.isSelected.toggle()
        presenter.didTapAddToFavorites(isSelected: favoritesBarButton.isSelected)
    }
}

// MARK: - Setup Subviews

extension DetailViewController {

    override func embedSubviews() {
        super.embedSubviews()

        view.backgroundColor = .white
        view.addSubview(scrollView)

        navigationItem.rightBarButtonItem = favoritesBarButton

        scrollView.addSubviews(nameLabel, newsImageView, descriptionLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()

        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)

        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }

        newsImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(newsImageView.snp.width)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(newsImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-20)
        }
    }
}

// MARK: - View Protocol

extension DetailViewController: DetailViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData() {
        favoritesBarButton.isSelected = presenter.isAddedToFavorites
        configure()
    }
}
