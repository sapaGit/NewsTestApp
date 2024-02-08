//
//  ViewController.swift
//  NewsApp
//

import UIKit
import SnapKit

private enum Constants {
    static let padding: CGFloat = 20.0
    static let cellHeight: CGFloat = 170
}

protocol NewsViewProtocol: BaseViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData()
    /// Navigates to ViewController
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

final class NewsViewController: BaseViewController {

    // MARK: - Properties

    var presenter: NewsPresenterProtocol!

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()

        for item in SegmentItem.allCases {
            segmentedControl.insertSegment(withTitle: item.title, at: segmentedControl.numberOfSegments, animated: false)
        }
        segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = .zero

        return segmentedControl
    }()

    private lazy var newsTableView: UITableView = {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    // MARK: - Private methods

    @objc
    private func didChangeSegment() {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        presenter.segmentDidChange(selectedSegmentIndex: selectedSegmentIndex)
    }

    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 120))
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

        view.backgroundColor = .secondarySystemBackground
        view.addSubviews(segmentedControl, newsTableView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.padding)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.padding)
        }

        newsTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).inset(-Constants.padding)
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


