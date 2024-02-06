//
//  ViewController.swift
//  NewsApp
//


import UIKit
import SnapKit

private enum Constants {
    static let padding: CGFloat = 20.0
    static let logoutButtonWidth: CGFloat = 100.0
    static let logoutButtonHeight: CGFloat = 44.0
    static let logoutCornerRadius: CGFloat = 10.0
    static let tableViewRowHeight = 170.0
}

protocol NewsViewProtocol: BaseViewProtocol {
    /// Notifies that new data has been received.
    func didReceiveData()
    /// Navigates to ViewController
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

final class NewsViewController: BaseViewController {

    // MARK: - Properties

    var selectedNewsHandler: (([NewsData]) -> Void)?
    var selectedNews: [NewsData] = []

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

    // MARK: - Actions

    @objc
    private func didChangeSegment() {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        presenter.segmentDidChange(selectedSegmentIndex: selectedSegmentIndex)
    }

    func checkBoxChanged(to isSelected: Bool, value: NewsData) {
        if isSelected {
            selectedNews.append(value)
        } else {
            selectedNews = selectedNews.filter { $0.articleID != value.articleID }
        }
    }
}

// MARK: - Setup Subviews

extension NewsViewController {

    override func embedSubviews() {
        super.embedSubviews()

        view.backgroundColor = .secondarySystemBackground

        [
            segmentedControl,
            newsTableView
        ].forEach(view.addSubview)
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
        newsTableView.reloadData()
    }
}

// MARK: - UITableView Delegate

extension NewsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableViewRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = presenter.news[indexPath.row]
        presenter.didSelectSettingsRow(item: currentItem)
    }
}

// MARK: - UITableView Data Source

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Unable to dequeue cell")
        }
        let currentNews = presenter.news[indexPath.row]
        cell.configure(model: currentNews)

        return cell
    }
}


