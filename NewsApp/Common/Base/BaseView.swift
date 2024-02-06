//
//  BaseView.swift
//  NewsApp
//

import UIKit

class BaseView: UIView {

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupSubviews()
    }

    // MARK: - Override methods

    override func layoutSubviews() {
        super.layoutSubviews()

        updateSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Setup Subviews

@objc extension BaseView {

    /// Sets up the view's subviews and their constraints.
    func setupSubviews() {
        embedSubviews()
        setupConstraints()
    }

    /// Updates the view's subviews after layout updates.
    func updateSubviews() {}

    /// Embeds subviews within the view.
    func embedSubviews() {}

    /// Sets up constraints for subviews.
    func setupConstraints() {}

    /// Updates constraints for subviews after layout updates.
    func updateSubviewsConstraints() {}
}
