//
//  ViewController.swift
//  NewsApp
//

import UIKit
import SnapKit

private enum Constants {
    static let padding: CGFloat = 20.0
    static let cellHeight: CGFloat = 170
    static let tableViewBorderWidth: CGFloat = 2
    static let footerHeight: CGFloat = 120
}

protocol NewsViewProtocol: BaseViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData()
    /// Navigates to ViewController
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

final class NewsViewController: BaseViewController {

    // MARK: - Properties

    private lazy var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.layer.borderWidth = Constants.tableViewBorderWidth
        tableView.layer.borderColor = UIColor(.white).withAlphaComponent(0.1).cgColor
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)

        return tableView
    }()

    // MARK: - Dependencies

    var presenter: NewsPresenterProtocol!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    // MARK: - Private methods

    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: Constants.footerHeight
        ))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }
}

// MARK: - Setup Subviews

extension NewsViewController {

    override func embedSubviews() {
        super.embedSubviews()

        title = String.News.title
        view.backgroundColor = .secondarySystemBackground
        view.addSubviews(newsTableView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        newsTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.padding)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - View Protocol

extension NewsViewController: NewsViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData() {
        newsTableView.tableFooterView = nil
        newsTableView.reloadData()
    }
}

// MARK: - UITableView Delegate

extension NewsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = presenter.newsDataArray[indexPath.row]
        presenter.didSelectNewsRow(item: currentItem)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
}

// MARK: - UITableView DataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.newsDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Unable to dequeue the cell")
        }
        let currentNews = presenter.newsDataArray[indexPath.row]
        cell.configure(model: currentNews)

        return cell
    }
}

// MARK: - UIScrollView Delegate

extension NewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (newsTableView.contentSize.height+130-scrollView.frame.size.height) && presenter.canPaginating {
            newsTableView.tableFooterView = createSpinnerFooter()
            presenter.didStartPagination()
        }
    }
}


