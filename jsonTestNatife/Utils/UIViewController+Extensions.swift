//
//  UIViewController+Extensions.swift
//  jsonTestNatife
//
//  Created by user on 11.09.2023.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        return Self(nibName: String(describing: self), bundle: nil)
    }
}
