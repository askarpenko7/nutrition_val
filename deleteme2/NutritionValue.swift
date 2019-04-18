//
//  NutritionValue.swift
//  deleteme2
//
//  Created by Alexander Karpenko on 17/04/2019.
//  Copyright © 2019 Alexander Karpenko. All rights reserved.
//

import UIKit

class NutritionValue: UIView {
    
    private var duration = 1
    private var kcal = 0.0
    private var startKCalValue = 0.0
    private var percent = 0.0
    
    private lazy var kcalLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bounds.width, height: bounds.height)))
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var foregroundLayer: CAShapeLayer = {
        let foreground = CAShapeLayer()
        foreground.lineWidth = 10
        foreground.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        foreground.lineCap = .round
        foreground.fillColor = UIColor.clear.cgColor
        foreground.strokeEnd = 0
        foreground.frame = bounds
        return foreground
    }()
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let background = CAShapeLayer()
        background.lineWidth = 10
        background.strokeColor = #colorLiteral(red: 1, green: 0.937254902, blue: 0.662745098, alpha: 1).cgColor
        background.lineCap = .round
        background.fillColor = UIColor.clear.cgColor
        background.frame = bounds
        return background
    }()
    
    private lazy var foregroundGradientLayer: CAGradientLayer = {
       let foregroundGradient = CAGradientLayer()
        foregroundGradient.frame = bounds
        let colorOne = #colorLiteral(red: 1, green: 0.8235294118, blue: 0.01568627451, alpha: 1).cgColor
        let colorTwo = #colorLiteral(red: 0.9245265126, green: 0.7113671899, blue: 0.3063792586, alpha: 1).cgColor
        foregroundGradient.colors = [colorOne, colorTwo]
        foregroundGradient.startPoint = CGPoint(x: 0, y: 0)
        foregroundGradient.endPoint = CGPoint(x: 1, y: 1)
        return foregroundGradient
    }()
    
    private lazy var pulseGradientLayer: CAGradientLayer = {
        let pulseGradient = CAGradientLayer()
        pulseGradient.frame = bounds
        let colorOne = #colorLiteral(red: 1, green: 0.6588235294, blue: 0.1411764706, alpha: 1)
        let colorTwo = #colorLiteral(red: 0.4808062315, green: 0.3693349957, blue: 0.162253052, alpha: 1)
        pulseGradient.colors = [colorOne, colorTwo]
        pulseGradient.startPoint = CGPoint(x: 0, y: 0)
        pulseGradient.endPoint = CGPoint(x: 0, y: 0)
        return pulseGradient
    }()
    
    func updateWith(kcal: Double, percent: Double) {
        self.kcal = kcal
        self.percent = percent
        animateCircleBy(percent: self.percent)
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdateKcal))
        displayLink.add(to: .main, forMode: .default)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpdateKcal(){
        if startKCalValue >= kcal {
            self.kcalLabel.text = "\(kcal)"
        } else {
            startKCalValue += Double((duration * 100)) / kcal
            kcalLabel.text = "\(String.init(format: "%.1f", self.startKCalValue))"
        }
    }
    
    private func loadLayers(){
        let centerPoint = CGPoint(x: frame.width/2, y: frame.height/2)
        
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: -.pi/2, endAngle: 2 * .pi - .pi/2, clockwise: true)
        
        backgroundLayer.path = circularPath.cgPath
        
        layer.addSublayer(backgroundLayer)
        
        foregroundLayer.path = circularPath.cgPath
        
        foregroundGradientLayer.mask = foregroundLayer
        
        layer.addSublayer(foregroundGradientLayer)
        
        addSubview(kcalLabel)
    }
    
    private func animateCircleBy(percent: Double) {
        let foregroundAnimation = CABasicAnimation(keyPath: "strokeEnd")
        foregroundAnimation.fromValue = 0
        foregroundAnimation.toValue = percent
        foregroundAnimation.duration = CFTimeInterval(duration)
        foregroundAnimation.fillMode = CAMediaTimingFillMode.forwards
        foregroundAnimation.isRemovedOnCompletion = false
        foregroundLayer.add(foregroundAnimation, forKey: "foregroundAnimation")
    }
    
    func restoreView(){
        startKCalValue = 0
        animateCircleBy(percent: self.percent)
    }
}
