//
//  MyFoodViewControllerViewModel.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import Foundation


import CoreData
///Manages data for MyFoodViewController
class MyFoodViewModel{
    var foods:[Food] = [Food]()
    
    func fetchData(completion:@escaping ()->()){
        DispatchQueue.background(background: {
            let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
            let predicate = NSPredicate(format: "lastEaten == nil")
            fetchRequest.predicate = predicate
            do{
                let foods = try PersistenceService.context.fetch(fetchRequest)
                self.foods = foods
            } catch{
            }
            
        }, completion:{
            completion()
        })
    }
    
    func editFood(food:Food, name:String, calories:Int, data:Data){
        DispatchQueue.background(background: { [weak self] in
            let object = PersistenceService.context.object(with: food.objectID)
            object.setValue(name, forKey: "name")
            object.setValue(calories, forKey: "calories")
            object.setValue(data, forKey: "image")
            PersistenceService.saveContext()
            
            let foodRef = self?.foods.first { (foodElem) -> Bool in
                return foodElem == food
            }
            foodRef?.name = name
            foodRef?.calories = Int16(calories)
            foodRef?.image = data
        })
        
    }
    
    func addFood(name:String, calories:Int, data:Data, completion: @escaping ()->()){
        DispatchQueue.background(background: { [weak self] in
            let food = Food(context: PersistenceService.context)
            food.image = data
            food.name = name
            food.calories = Int16(calories)
            PersistenceService.saveContext()
            self?.foods.append(food)
            }, completion: {
                completion()
        })
    }
    
    func remove(index:Int){

        let context = PersistenceService.context
            context.delete((self.foods[index]) as NSManagedObject)
            self.foods.remove(at: index)
            do{
                try context.save()}
            catch{
                
            }
    }
}
