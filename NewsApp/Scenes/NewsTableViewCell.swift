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

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = .lightGray
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill

        return imageView
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
        dateLabel.text = nil
        authorLabel.text = nil
        newsImageView.image = nil
    }

    func configure(model: News) {
        nameLabel.text = model.title?.capitalized
        authorLabel.text = model.creator
        dateLabel.text = model.pubDate?.toDateFormattedString()
        guard let imageURL = model.imageURL else {return}
        let url = URL(string: imageURL)

        imageDownloadTask?.cancel()
        let placehoder = UIImage(systemName: "photo")
        imageDownloadTask = newsImageView.kf.setImage(with: url, placeholder: placehoder)
    }
}

// MARK: - Setup Subviews

extension NewsTableViewCell {
    override func setupSubviews() {
        super.setupSubviews()

        backgroundColor = .clear
    }

    override func embedSubviews() {
        backgroundViewCell.addSubviews(
            nameLabel,
            authorLabel,
            dateLabel,
            newsImageView
        )
        addSubviews(backgroundViewCell)
    }

    override func setupConstraints() {

        authorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(Constants.padding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.padding)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).inset(-3)
            $0.leading.equalToSuperview().inset(Constants.padding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.padding)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-10)
            $0.leading.equalToSuperview().inset(Constants.padding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.padding)
        }

        newsImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(Constants.disclosureImageSize)
            $0.top.bottom.equalToSuperview().inset(5)
        }
        backgroundViewCell.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.backgroundInset)
        }
    }
}

