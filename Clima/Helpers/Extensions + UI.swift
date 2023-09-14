//
//  Extensions + UI.swift
//  Clima
//
//  Created by Анастасия Рыбакова on 07.09.2023.
//

import UIKit


// MARK: - Extension UI

extension UIButton {
    convenience init(backgroundImage: String) {
        self.init(type: .system)
        self.setBackgroundImage(UIImage(systemName: backgroundImage), for: .normal)
//        button.tintColor = .label
        self.tintColor = UIColor(named: Constants.weatherColor)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension UILabel {
    convenience init(text: String, size: CGFloat, weight: UIFont.Weight) {
        self.init()
        self.text = text
        self.font = .systemFont(ofSize: size, weight: weight)
        self.textColor = UIColor(named: Constants.weatherColor)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment,  spacing: CGFloat) {
        self.init()
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
