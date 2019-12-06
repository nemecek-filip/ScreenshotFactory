//
//  UIViewExtensions.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 06/12/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

extension UIView {
    func applyLightShadow(color: UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
    
    func applyMediumShadow(color: UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
}
