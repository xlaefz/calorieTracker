//
//  FoodCell.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    var foodImageView = UIImageView()
    var foodTitleLabel = UILabel()
    var link:AddFoodTodayViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(foodImageView)
        addSubview(foodTitleLabel)
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        
        if link != nil{
            
        }
    }
    
    @objc private func handleMarkAsFavorite(){
        print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
    }
    
    func addLink(_ _link: AddFoodTodayViewController){
        link = _link
        let starButton = UIButton(type: .system)
            starButton.setImage(UIImage(named: "fav_star"), for: .normal)
            starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            starButton.tintColor = .red
            accessoryView = starButton
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView(){
        foodImageView.layer.cornerRadius = 10
        foodImageView.clipsToBounds = true
    }
    
    func configureTitleLabel(){
        foodTitleLabel.numberOfLines = 0
        foodTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints(){
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        foodImageView.widthAnchor.constraint(equalTo: foodImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    func setTitleLabelConstraints(){
        foodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        foodTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foodTitleLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 20).isActive = true
        foodTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        foodTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    }
    
}
