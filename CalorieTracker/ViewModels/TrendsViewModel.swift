//
//  TrendsViewModel.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/13/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import Foundation
import CoreData

class TrendsViewModel{
    var foodsEatenPast7Days = [Food]()
    var foodsEatenAllTime = [Food]()
    let todaysDate = Date()
    
    func fetchData(){
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 7, to: dateFrom)
        let fromPredicate = NSPredicate(format: "lastEaten >= %@" , dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "lastEaten < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
        do{
            let foods = try PersistenceService.context.fetch(fetchRequest)
            
            self.foodsEatenPast7Days = foods.sorted(by: { (fooda, foodb) -> Bool in
                return fooda.lastEaten?.compare(foodb.lastEaten ?? Date()) == .orderedDescending
            })
        } catch{
        }
        
        let foodsFetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "lastEaten != nil")
        foodsFetchRequest.predicate = predicate
        do{
            let foods = try PersistenceService.context.fetch(foodsFetchRequest)
            self.foodsEatenAllTime = foods
            processData(foodsEatenAllTime)
        } catch{
        }
    }
    
    func getProcessed7DayData()->[ChartPoint]{
        return processData(foodsEatenPast7Days)
    }
    
    
    private func processData(_ foods:[Food])->[ChartPoint]{
        var calendarMap = [Date:Int]()
        var sol = [ChartPoint]()
        for food in foods{
            guard let date = food.lastEaten else { return []}
            let startOfDate = Calendar.current.startOfDay(for: date)
            calendarMap[startOfDate, default: 0] += Int(food.calories)
        }
        for (key,value) in calendarMap{
            sol.append(ChartPoint(calories: value, date: key))
        }
        return sol
    }
    
    
    private func isInSameDay(_ date1:Date, _ date2:Date)->Bool{
        return Calendar.current.isDate(date1, inSameDayAs:date2)
    }
    
}


struct ChartPoint{
    var calories:Int
    var date:Date
}
