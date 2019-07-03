//
//  UIView+BoxStyle.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 7/2/19.
//

import UIKit

// MARK: Box Style
internal extension UIView {
    func applyBoxStyleRadius() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

    func applyBoxStyle() {
        self.applyBoxStyleRadius()
        self.dropShadow(radius: 5, opacity: 0.15)
    }
}
