//
//  NewsTableViewCell.swift
//  NewsApp
//

import UIKit
import SnapKit
import Kingfisher

private enum Constants {
    static let backgroundBorderWidth: CGFloat = 1.0
    static let backgroundCornerRadius: CGFloat = 10.0
    static let disclosureImageSize: CGFloat = 150.0
    static let padding: CGFloat = 20.0
    static let backgroundInset: CGFloat = 10.0
}

final class NewsTableViewCell: BaseTableViewCell {

    // MARK: - Properties

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private lazy var backgroundViewCell: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.borderWidth = Constants.backgroundBorderWidth
        view.layer.cornerRadius = Constants.backgroundCornerRadius
        view.layer.borderColor = UIColor.lightGray.cgColor

        return view
    }()

    private var imageDownloadTask: DownloadTask?
}

// MARK: - Internal methods
extension NewsTableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()

        imageDownloadTask?.cancel()
        nameLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(model: NewsData) {
        nameLabel.text = model.title.capitalized
        guard let imageURL = model.imageURL else {return}
        let url = URL(string: imageURL)

        imageDownloadTask?.cancel()

        imageDownloadTask = newsImageView.kf.setImage(with: url)
    }
}

// MARK: - Setup Subviews

extension NewsTableViewCell {
    override func setupSubviews() {
        super.setupSubviews()

        backgroundColor = .clear
    }

    override func embedSubviews() {
        backgroundViewCell.addSubviews(nameLabel, newsImageView)
        addSubviews(backgroundViewCell)
    }

    override func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.padding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.padding)
        }

        newsImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.size.equalTo(Constants.disclosureImageSize)
        }

        backgroundViewCell.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.backgroundInset)
        }
    }
}

