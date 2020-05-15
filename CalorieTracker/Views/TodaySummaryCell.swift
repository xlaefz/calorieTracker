//
//  TodaySummaryCell.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/13/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class TodaySummaryCell: UITableViewCell {
    var caloriesToday:Int?
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer:CAShapeLayer!
    var percentageLabel:UILabel = {
        let label = UILabel()
        label.text = "100%"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    var detailLabel:UILabel = {
        let label = UILabel()
        label.text = "of 2000cal"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .systemGray5
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        //track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.position = self.contentView.center
        trackLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.backgroundColor.cgColor
        
        trackLayer.lineCap = .round
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.position = self.contentView.center
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 20
        pulsatingLayer.fillColor = UIColor.pulsatingFillColor.cgColor
        pulsatingLayer.lineCap = .round
        
        
        //shape layer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.position = self.contentView.center
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        
        
        if !(self.contentView.layer.sublayers?.contains(shapeLayer) ?? false)
        {
            animatePulsatingLayer()
            layer.addSublayer(pulsatingLayer)
            
            layer.addSublayer(trackLayer)
            self.layer.addSublayer(shapeLayer)
            percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            percentageLabel.center = contentView.center
            detailLabel.frame = CGRect(x: 0, y: 50, width: 300, height: 100)
            detailLabel.center = CGPoint(x: 187.5+120, y: contentView.center.y+35)
            //            detailLabel.center = contentView.center
            addSubview(percentageLabel)
            addSubview(detailLabel)
            
            percentageLabel.translatesAutoresizingMaskIntoConstraints = false
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant:  -20).isActive = true
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            percentageLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            percentageLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true

            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true// (detailLabel.text?.width(withConstrainedHeight: 100, font: .systemFont(ofSize: 15)) ?? 0)/2 ?? 0).isActive = true
           detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30).isActive = true

            detailLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            detailLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
        }
    }
    
    
    
    
    func animate(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        guard let _caloriesToday = caloriesToday else { return }
        basicAnimation.toValue = (Double(_caloriesToday)/Double(2000))
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
        
    }
    
    private func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        animate()
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground(){
        animatePulsatingLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    static func rgb(r:CGFloat, g:CGFloat, b:CGFloat)->UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33   )
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}
