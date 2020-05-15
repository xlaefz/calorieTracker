//
//  TitleStackView.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/14/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

///Hack the tableview to look like Large Text Header
class TitleStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        axis = .horizontal
        alignment = .center
        addArrangedSubview(titleLabel)
        addArrangedSubview(button)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .heavy)
        label.text = ""
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let buttonWidth: CGFloat = 50
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: buttonWidth)))
        button.setTitleColor(.systemBlue, for: .normal)
        //        button.setTitle("🖊", for: .normal)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
}
