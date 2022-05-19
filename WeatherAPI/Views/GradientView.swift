//
//  GradientView.swift
//  KyivstarTVOS
//
//  Created by IhorP on 20.09.2021.
//

import UIKit

class GradientView: UIView {

    var colors: [UIColor] {
        didSet {
            updateColors()
        }
    }
    var locations: [Double]
    var gradientLayer: CAGradientLayer?
    init(colors: [UIColor], locations: [Double], direction: NSLayoutConstraint.Axis = .vertical) {
        self.colors = colors
        self.locations = locations

        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        colors = []
        locations = []
        super.init(coder: coder)
    }
    
    override var bounds: CGRect {
        didSet {
            updateGradient()
        }
    }
    
    
    private func updateColors() {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 0.5
        gradientChangeAnimation.toValue = colors.map { $0.cgColor }
        gradientChangeAnimation.fillMode = .forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientLayer?.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    private func updateGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.frame = self.bounds
        self.gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = gradientLayer
        self.layer.addSublayer(gradientLayer)
    }
}
