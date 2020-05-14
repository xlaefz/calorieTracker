//
//  MyFoodViewControllerViewModel.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import Foundation


import CoreData

class MyFoodViewModel{
    var foods:[Food] = [Food]()

    func fetchData(completion:()->()){
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "lastEaten == nil")
        fetchRequest.predicate = predicate
        do{
            let foods = try PersistenceService.context.fetch(fetchRequest)
            self.foods = foods
        } catch{
        }
        completion()
    }
    
    func editFood(food:Food, name:String, calories:Int, data:Data){
        let object = PersistenceService.context.object(with: food.objectID)
        object.setValue(name, forKey: "name")
        object.setValue(calories, forKey: "calories")
        object.setValue(data, forKey: "image")
        PersistenceService.saveContext()
        
        let foodRef = foods.first { (foodElem) -> Bool in
            return foodElem == food
        }
        foodRef?.name = name
        foodRef?.calories = Int16(calories)
        foodRef?.image = data
    }
    
    func addFood(name:String, calories:Int, data:Data){
        let food = Food(context: PersistenceService.context)
        food.image = data
        food.name = name
        food.calories = Int16(calories)
        PersistenceService.saveContext()
        foods.append(food)
    }
    
    func remove(index:Int){
        let context = PersistenceService.context
        context.delete(foods[index] as NSManagedObject)
        self.foods.remove(at: index)
        do{
            try context.save()}
        catch{
        
        }
    }
}
