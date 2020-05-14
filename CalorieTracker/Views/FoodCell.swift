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
    var calorieLabel = UILabel()
    var link:AddFoodTodayViewController?
    let cardView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        addSubview(cardView)
        cardView.pin(to: contentView, constant: 10)
        
        
        cardView.addSubview(foodImageView)
        cardView.addSubview(foodTitleLabel)
        cardView.addSubview(calorieLabel)
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        backgroundColor = .clear
        
    }
    
    override var isSelected: Bool{
        didSet{
            layoutSubviews()
        }
        willSet{
            layoutSubviews()
        }
    }
        
    @objc private func handleMarkAsFavorite(){
        link?.someMethodIWantToCall(cell: self)
    }
    
    func addLink(_ _link: AddFoodTodayViewController){
        link = _link
        let starButton = UIButton(type: .system)
        starButton.setImage(UIImage(named: "check_mark"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.tintColor = .red
        accessoryView = starButton
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView(){
        foodImageView.clipsToBounds = true
    }
    
    func configureTitleLabel(){
        foodTitleLabel.numberOfLines = 0
        foodTitleLabel.adjustsFontSizeToFitWidth = true
        foodTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        calorieLabel.numberOfLines = 0
        calorieLabel.adjustsFontSizeToFitWidth = true
        calorieLabel.font = UIFont.italicSystemFont(ofSize: 12)
        calorieLabel.textColor = .systemGray
    }
    
    func setImageConstraints(){
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.topAnchor.constraint(equalTo: cardView.topAnchor).isActive = true
//        foodImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foodImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: self.bounds.size.height+50).isActive = true
        foodImageView.widthAnchor.constraint(equalTo: foodImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setTitleLabelConstraints(){
        foodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        foodTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5).isActive = true
        foodTitleLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 20).isActive = true
        foodTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        foodTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieLabel.topAnchor.constraint(equalTo: foodTitleLabel.bottomAnchor).isActive = true
        calorieLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 20).isActive = true
        calorieLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calorieLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        
    }
    
    func setUpCellWithFood(_ food:Food){
        let caloriesString = String(food.calories)
        foodTitleLabel.text = "\(food.name?.capitalized ?? "")"
        calorieLabel.text = "\(caloriesString) cal"
        if let data = food.image{
            foodImageView.image = UIImage(data: data)
        }
        contentView.backgroundColor = UIColor.clear
    }
    
}
