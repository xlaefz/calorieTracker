//
//  MyFoodViewControllerViewModel.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import Foundation

struct Food{
    var name:String
    var calories:Int
    var image:Data
}

class MyFoodViewModel{
    var foods:[Food]?
    
    init() {
        //handle cache here later
        if foods == nil{
            foods = [Food]()
        }
    }
    
    func addFood(name:String, calories:Int, data:Data){
        let food = Food(name: name, calories: calories, image:data)
        foods?.append(food)
    }
}
