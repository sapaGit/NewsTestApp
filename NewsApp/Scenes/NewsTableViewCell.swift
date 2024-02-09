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
    static let imageWidth: CGFloat = 150.0
    static let imageHeight: CGFloat = 100.0
    static let trailingPadding: CGFloat = 20.0
    static let mainPadding: CGFloat = 5.0
    static let backgroundInset: CGFloat = 10.0
    static let labelFont: CGFloat = 12.0
    static let secondatyLabelFont: CGFloat = 10.0
}

final class NewsTableViewCell: BaseTableViewCell {

    // MARK: - Properties

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: Constants.secondatyLabelFont)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.secondatyLabelFont, weight: .light)
        label.textColor = .lightGray
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.labelFont, weight: .semibold)
        label.numberOfLines = .zero
        label.textAlignment = .left

        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "photo")
        imageView.tintColor = .lightGray
        imageView.image = image
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

    // MARK: - PrepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()

        imageDownloadTask?.cancel()

        nameLabel.text = nil
        dateLabel.text = nil
        authorLabel.text = nil
        newsImageView.image = UIImage(systemName: "photo")
    }
}

// MARK: - Internal methods

extension NewsTableViewCell {

    func configure(model: NewsData) {
        nameLabel.text = model.title?.capitalized
        authorLabel.text = model.creator?.first
        dateLabel.text = model.pubDate?.toDateFormattedString()
        guard let imageURL = model.imageURL else {return}
        let url = URL(string: imageURL)

        imageDownloadTask?.cancel()
        let placehoder = UIImage(systemName: "photo")
        let processor = DownsamplingImageProcessor(size: CGSize(
            width: Constants.imageWidth,
            height: Constants.imageHeight))
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        imageDownloadTask = newsImageView.kf.setImage(
            with: url, 
            placeholder: placehoder,
            options: options
        )
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
            $0.top.equalToSuperview().inset(Constants.mainPadding)
            $0.leading.equalToSuperview().inset(Constants.trailingPadding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.trailingPadding)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).inset(-Constants.mainPadding)
            $0.leading.equalToSuperview().inset(Constants.trailingPadding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.trailingPadding)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-Constants.mainPadding).multipliedBy(1.3)
            $0.leading.equalToSuperview().inset(Constants.trailingPadding)
            $0.trailing.equalTo(newsImageView.snp.leading).inset(-Constants.trailingPadding)
        }

        newsImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.mainPadding)
            $0.width.equalTo(Constants.imageWidth)
            $0.top.bottom.equalToSuperview().inset(Constants.mainPadding)
        }
        backgroundViewCell.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.backgroundInset)
        }
    }
}

