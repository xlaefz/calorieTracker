//
//  TodayViewModel.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import Foundation
import CoreData

/// Manages TodayViewController/AddFoodViewController Data
class TodayViewModel{
    var foodsEatenToday = [Food]()
    var foods = [Food]()
    let todaysDate = Date()
    var foodsToAdd = Set<Food>()
    
    func fetchData(completion:@escaping ()->()){
        DispatchQueue.background(background: { [weak self] in
            
            let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: Date())
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            let fromPredicate = NSPredicate(format: "lastEaten >= %@" , dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "lastEaten < %@", dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            fetchRequest.predicate = datePredicate
            do{
                let foods = try PersistenceService.context.fetch(fetchRequest)
                self?.foodsEatenToday = foods
            } catch{
            }
            
            let foodsFetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
            let predicate = NSPredicate(format: "lastEaten == nil")
            foodsFetchRequest.predicate = predicate
            do{
                let foods = try PersistenceService.context.fetch(foodsFetchRequest)
                self?.foods = foods
            } catch{
            }
            },completion: {
                completion()
        })
    }
    
    func addFood(food:Food){
        foodsToAdd.insert(food)
        let _food = Food(context: PersistenceService.context)
        _food.name = food.name
        _food.image = food.image
        _food.calories = food.calories
        _food.setValue(Date(), forKey: "lastEaten")
        foodsEatenToday.append(_food)
        PersistenceService.saveContext()
    }
    
    
    func addFakeData(){
        let food = foods[0]
        for i in 0..<30{
            let _food = Food(context: PersistenceService.context)
            _food.name = food.name
            _food.image = food.image
            _food.calories = food.calories - Int16(i*3)
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            _food.setValue(date, forKey: "lastEaten")
            PersistenceService.saveContext()
        }
    }
    
    func todayCalories()->Int {
        var value = 0
        for food in foodsEatenToday{
            value += Int(food.calories)
        }
        return value
    }
    
    func remove(food:Food){
        foodsToAdd.remove(food)
        let context = PersistenceService.context
        let index = foodsEatenToday.firstIndex(where: { (_food) -> Bool in
            return _food.name == food.name && food.calories == _food.calories
        })
        guard let _index = index else { return }
        context.delete(foodsEatenToday[_index] as NSManagedObject)
        self.foodsEatenToday.remove(at: _index)
        do{
            try context.save()}
        catch{
            
        }
    }
    
    func remove(index:Int){
        let context = PersistenceService.context
        context.delete(foodsEatenToday[index] as NSManagedObject)
        self.foodsEatenToday.remove(at: index)
        do{
            try context.save()}
        catch{
            
        }
    }
}
