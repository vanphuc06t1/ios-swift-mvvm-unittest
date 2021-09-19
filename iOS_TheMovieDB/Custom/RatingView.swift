//
//  RatingView.swift
//  iOS_TheMovieDB
//
//  Copyright © 2021 PhucBui. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    var labelPercentage : UILabel!
    var labelPercentageNumber : UILabel!
    var roundView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    private func initSubviews() {
        self.backgroundColor = .clear
        
        initPercentageLabel()
        initPercentageLabelNumber()

    }
    
    private func initPercentageLabel() {
        
        labelPercentage = UILabel()
        labelPercentage.font = UIFont.systemFont(ofSize: 6)
        labelPercentage.textColor = .white
        labelPercentage.backgroundColor = .clear
        labelPercentage.textAlignment = .center
        labelPercentage.text = "%"
        //Add subview
        self.labelPercentage.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        self.addSubview(self.labelPercentage)
        //Autolayout
        self.labelPercentage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.labelPercentage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.labelPercentage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            self.labelPercentage.heightAnchor.constraint(equalToConstant: 10),
            self.labelPercentage.widthAnchor.constraint(equalToConstant: 10)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func initPercentageLabelNumber() {
        
        labelPercentageNumber = UILabel()
        labelPercentageNumber.font = UIFont.systemFont(ofSize: 15)
        labelPercentageNumber.textColor = .white
        labelPercentageNumber.backgroundColor = .clear
        labelPercentageNumber.textAlignment = .center
        
        self.labelPercentageNumber.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
        self.addSubview(self.labelPercentageNumber)
        
        self.labelPercentageNumber.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.labelPercentageNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            self.labelPercentageNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            self.labelPercentageNumber.heightAnchor.constraint(equalToConstant: bounds.width),
            self.labelPercentageNumber.widthAnchor.constraint(equalToConstant: bounds.width)
            
        ]
        
        NSLayoutConstraint.activate(constraints)

    }
    
    func updateCirclePercentage(percent: Double) {
        // round view
        if roundView != nil {
            return
        }
        roundView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        roundView.backgroundColor = .clear
        roundView.layer.cornerRadius = roundView.frame.size.width / 2

        // bezier path
        let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
                                      radius: roundView.frame.size.width / 2,
                                      startAngle: CGFloat(-0.5 * .pi),
                                      endAngle: CGFloat(1.5 * .pi),
                                      clockwise: true)
        
        // circle shape background 100%. Alpha color 0.3
        let circleShapeBackground = CAShapeLayer()
        circleShapeBackground.path = circlePath.cgPath
        circleShapeBackground.strokeColor = (percent > 0.5) ? UIColor.green.withAlphaComponent(0.3).cgColor : UIColor.yellow.withAlphaComponent(0.3).cgColor
        circleShapeBackground.fillColor = UIColor.clear.cgColor
        circleShapeBackground.lineWidth = 2.5
        // set start and end values
        circleShapeBackground.strokeStart = 0.0
        circleShapeBackground.strokeEnd = CGFloat(1)
        roundView.layer.addSublayer(circleShapeBackground)
        
        // circle shape percentage
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = (percent > 0.5) ? UIColor.green.cgColor : UIColor.yellow.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 2.5
        // set start and end values
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = CGFloat(percent/10)
        
        // add sublayer
        roundView.layer.addSublayer(circleShape)

        // add subview
        self.addSubview(roundView)
        
        //Update percentage value
        let percentValue  = (percent*10).rounded()
        labelPercentageNumber.text = String(format: "%.0f", percentValue)
    }
}
