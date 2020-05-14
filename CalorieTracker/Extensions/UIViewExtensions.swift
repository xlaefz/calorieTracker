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
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
           
           translatesAutoresizingMaskIntoConstraints = false
           
           if let top = top {
               self.topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
           }
           
           if let leading = leading {
               self.leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
           }
           
           if let bottom = bottom {
               self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
           }
           
           if let trailing = trailing {
               self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
           }
           
           if size.width != 0 {
               self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
           }
           
           if size.height != 0 {
               self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
           }
           
       }
       
       func fillSuperview(padding: UIEdgeInsets) {
           translatesAutoresizingMaskIntoConstraints = false
           if let superviewTopAnchor = superview?.topAnchor {
               topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
           }
           
           if let superviewBottomAnchor = superview?.bottomAnchor {
               bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
           }
           
           if let superviewLeadingAnchor = superview?.leadingAnchor {
               leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
           }
           
           if let superviewTrailingAnchor = superview?.trailingAnchor {
               trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
           }
       }
}
