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
    var data = [[ChartPoint]]()
    func fetchData(completion:@escaping ()->()){
        DispatchQueue.background(background: { [weak self] in
            guard let self = self else { return }
            self.data = [[ChartPoint]]()
            let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            // Get today's beginning & end
            let dateFrom = calendar.date(byAdding: .day, value: -7, to: Date())
            let dateTo = Date()
            let fromPredicate = NSPredicate(format: "lastEaten >= %@" , dateFrom! as NSDate)
            let toPredicate = NSPredicate(format: "lastEaten <= %@", dateTo as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            fetchRequest.predicate = datePredicate
            do{
                let foods = try PersistenceService.context.fetch(fetchRequest)
                self.foodsEatenPast7Days = foods
                if !foods.isEmpty{
                    self.data.append(self.getProcessedData(foods))
                }            } catch{
            }
            
            let foodsFetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
            let predicate = NSPredicate(format: "lastEaten != nil")
            foodsFetchRequest.predicate = predicate
            do{
                let foods = try PersistenceService.context.fetch(foodsFetchRequest)
                self.foodsEatenAllTime = foods.sorted(by: { (fooda, foodb) -> Bool in
                    return fooda.lastEaten?.compare(foodb.lastEaten ?? Date()) == .orderedDescending
                })
                if !foods.isEmpty{
                    self.data.append(self.getProcessedData(foods))
                }
            } catch{
            }},completion:{
                completion()
        })
        
    }
    
    func getProcessedData(_ foods:[Food])->[ChartPoint]{
        return processData(foodsEatenPast7Days)
    }
    
    func getProcessedData(forSection index:Int)->[ChartPoint]{
        if index == 0{
            return processData(foodsEatenPast7Days)
        }
        return processData(foodsEatenAllTime)
    }
    
    func getSectionTitle(forSection index:Int)->String{
        if index == 0{
            return "Calories Past 7 Days"
        }
        return "Calories Over Time"
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
        return sol.sorted { (a, b) -> Bool in
            return a.date < b.date
        }
    }
    
    
    private func isInSameDay(_ date1:Date, _ date2:Date)->Bool{
        return Calendar.current.isDate(date1, inSameDayAs:date2)
    }
    
}


struct ChartPoint{
    var calories:Int
    var date:Date
}
