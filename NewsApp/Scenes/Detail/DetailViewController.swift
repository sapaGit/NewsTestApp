//
//  DetailViewController.swift
//  NewsApp
//


import UIKit
import SnapKit
import Kingfisher

private enum Constants {
    static let topPadding: CGFloat = 20.0
}

protocol DetailViewProtocol: BaseViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData()

    func updateFavoritesButton() 
}

final class DetailViewController: BaseViewController {

    // MARK: - Properties

    var presenter: DetailPresenterProtocol!

    private let scrollView = UIScrollView()

    private let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill

        return stackView
    }()

    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .center

        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .center

        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "photo")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .center

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }

    func configure() {
        creatorLabel.text = presenter.creatorText
        nameLabel.text = presenter.nameText
        newsImageView.image = presenter.newsImage
        descriptionLabel.text = presenter.descriptionText
        sourceLabel.text = presenter.sourceText

        favoritesBarButton.isSelected = presenter.isAddedToFavorites
    }

    func updateFavoritesButton() {
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

        scrollView.addSubview(vStack)

        vStack.addArrangedSubviews(
            creatorLabel,
            nameLabel,
            newsImageView,
            descriptionLabel,
            sourceLabel)

        navigationItem.rightBarButtonItem = favoritesBarButton

    }

    override func setupConstraints() {
        super.setupConstraints()

        newsImageView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)

        }

        vStack.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
            $0.width.equalTo(view.snp.width)
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
