//
//  BaseTableViewCell.swift
//  NewsApp
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupSubviews()
    }

    // MARK: - Override method

    override func layoutSubviews() {
        super.layoutSubviews()

        updateSubviews()
    }
}

// MARK: - Setup Subviews

@objc extension BaseTableViewCell {

    /// Sets up the cell's subviews and their constraints.
    func setupSubviews() {
        selectionStyle = .none

        embedSubviews()
        setupConstraints()
    }

    /// Updates the cell's subviews after layout updates.
    func updateSubviews() {}
    /// Embeds subviews within the cell.
    func embedSubviews() {}
    /// Sets up constraints for subviews.
    func setupConstraints() {}
}

