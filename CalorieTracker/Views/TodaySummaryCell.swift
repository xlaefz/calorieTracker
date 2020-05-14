//
//  TodaySummaryCell.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/13/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class TodaySummaryCell: UITableViewCell {
    
    @IBOutlet weak var calories: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let view = UIView()
        view.backgroundColor = .red
        addSubview(view)
        view.pin(to: contentView)
        let center = view.center
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        view.layer.addSublayer(shapeLayer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
