//
//  AddFoodTodayViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

protocol AddFoodDelegate {
    func addFood(cell: UITableViewCell)
}

class AddFoodTodayViewController: UIViewController {
    let tableView = UITableView()
    var viewModel:TodayViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
}

extension AddFoodTodayViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.foods.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        guard let food = self.viewModel?.foods[indexPath.row] else { return UITableViewCell() }
        cell.setUpCellWithFood(food)
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

extension AddFoodTodayViewController:AddFoodDelegate{
    
     func addFood(cell: UITableViewCell){
           guard  let indexPathClickedOn = tableView.indexPath(for: cell) else { return }
           guard let food = viewModel?.foods[indexPathClickedOn.row] else { return }
           let hasFavorited = viewModel?.foodsToAdd.contains(food) ?? false
           if hasFavorited{
               viewModel?.remove(food: food)
           }
           else{
               viewModel?.addFood(food: food)
           }
           tableView.reloadRows(at: [indexPathClickedOn], with: .automatic)
       }
}
