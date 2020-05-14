//
//  AddFoodTodayViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class AddFoodTodayViewController: UIViewController {
    let tableView = UITableView()
    var viewModel:TodayViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.pin(to:view)
        tableView.register(FoodCell.self, forCellReuseIdentifier: "FoodCell")
        tableView.separatorColor = .clear
        tableView.backgroundColor = .systemGray5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.foodsToAdd.removeAll()
    }
    
    // TODO: SHOULD USE DELEGATION
    func someMethodIWantToCall(cell: UITableViewCell){
        guard  let indexPathClickedOn = tableView.indexPath(for: cell) else { return }
        guard let food = viewModel?.foods[indexPathClickedOn.row] else { return }
        let hasFavorited = viewModel?.foodsToAdd.contains(food) ?? false
        if hasFavorited{
//            viewModel?.foodsToAdd.remove(food)
            viewModel?.remove(food: food)
        }
        else{
//            viewModel?.foodsToAdd.insert(food)
            viewModel?.addFood(food: food)
        }
        tableView.reloadRows(at: [indexPathClickedOn], with: .automatic)
    }
    
}

extension AddFoodTodayViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.foods.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        guard let food = self.viewModel?.foods[indexPath.row] else { return UITableViewCell() }
        let caloriesString = String(food.calories)
        cell.foodTitleLabel.text = "\(food.name ?? "")" + "  |  " + "\(caloriesString)"
        if let data = food.image{
            cell.foodImageView.image = UIImage(data: data)
        }
        cell.addLink(self)
        cell.accessoryView?.tintColor = viewModel?.foodsToAdd.contains(food) == true ? .green :.lightGray
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to:#selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}

extension AddFoodTodayViewController:UITableViewDelegate{
}
