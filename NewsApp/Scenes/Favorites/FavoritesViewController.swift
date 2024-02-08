//
//  FavoritesViewController.swift
//  NewsApp
//

import UIKit
import SnapKit

private enum Constants {
    static let padding: CGFloat = 20.0
    static let cellHeight: CGFloat = 170
}

protocol FavoritesViewProtocol: BaseViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData()
    /// Navigates to ViewController
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

final class FavoritesViewController: BaseViewController {

    // MARK: - Properties

    var presenter: FavoritesPresenterProtocol!

    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.layer.borderWidth = 2.0
        tableView.layer.borderColor = UIColor(.white).withAlphaComponent(0.1).cgColor
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)

        return tableView
    }()

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }
}

// MARK: - Setup Subviews

extension FavoritesViewController {

    override func embedSubviews() {
        super.embedSubviews()

        view.backgroundColor = .secondarySystemBackground
        view.addSubview(favoritesTableView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        favoritesTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }
}

// MARK: - View Protocol

extension FavoritesViewController: FavoritesViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData() {
        favoritesTableView.reloadData()
    }
}

// MARK: - UITableView Delegate

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = presenter.newsDataArray[indexPath.row]
        presenter.didSelectFavoritesRow(item: currentItem)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didDeleteRow(index: indexPath.row)
        }
    }
}

// MARK: - UITableView DataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.newsDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Unable to dequeue cell")
        }
        let currentNews = presenter.newsDataArray[indexPath.row]
        cell.configure(model: currentNews)

        return cell
    }
}



