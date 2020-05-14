//
//  UIViewExtensions.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/14/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

extension UIView{
    func pin(to superView:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
    func pin(to superView:UIView, constant:Int){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: CGFloat(constant)).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor,  constant: CGFloat(constant)).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor,  constant: CGFloat(-constant)).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor,  constant: CGFloat(-constant)).isActive = true
    }
    
}
