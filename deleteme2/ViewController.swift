//
//  ViewController.swift
//  deleteme2
//
//  Created by Alexander Karpenko on 17/04/2019.
//  Copyright © 2019 Alexander Karpenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let colorOne = #colorLiteral(red: 0.3606003523, green: 0.6708332896, blue: 0.9439496398, alpha: 1).cgColor
    let colorTwo = #colorLiteral(red: 0.7412833571, green: 0.1650635302, blue: 0.3386405408, alpha: 1).cgColor
    let colorThree = #colorLiteral(red: 0.9245265126, green: 0.7113671899, blue: 0.3063792586, alpha: 1).cgColor
    
    lazy var nutritionValView = NutritionValue(frame: CGRect(x: (view.frame.width - 200)/2, y: (view.frame.height - 200)/2, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientView()
        initNutritionValueView()
    }
    
    func createGradientView() {
        gradientSet.append([colorOne, colorTwo])
        gradientSet.append([colorTwo, colorThree])
        gradientSet.append([colorThree, colorOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        animateGradient()
        
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChageAnimation = CABasicAnimation(keyPath: "colors")
        gradientChageAnimation.duration = 3.0
        gradientChageAnimation.toValue = gradientSet[currentGradient]
        gradientChageAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChageAnimation.isRemovedOnCompletion = false
        gradientChageAnimation.delegate = self
        gradient.add(gradientChageAnimation, forKey: "gradientChageAnimation")
    }
    
    func initNutritionValueView() {
        nutritionValView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clearNutritionView)))
        view.addSubview(nutritionValView)
        nutritionValView.updateWith(kcal: 70, percent: 0.7)
        
    }
    
    @objc func clearNutritionView(){
        nutritionValView.restoreView()
    }
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

