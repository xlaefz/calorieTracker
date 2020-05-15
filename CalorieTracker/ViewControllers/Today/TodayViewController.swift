//
//  TodayViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = TodayViewModel()
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFAB()
    }
    
    private func showFAB(){
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData { [weak self] in
            self?.isLoading = false
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideFAB()
    }
    
    private func hideFAB(){
        if let view = UIApplication.shared.keyWindow, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
        }
    }
    
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableHeaderView?.backgroundColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.backgroundColor = UIColor.backgroundColor
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        tableView.separatorColor = .clear
        tableView.register(TodaySummaryCell.self, forCellReuseIdentifier: "SummaryCell")
        tableView.register(FoodCell.self, forCellReuseIdentifier: "FoodCell")
    }
    
    private lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func fabTapped(_ button: UIButton) {
        if viewModel.foods.count == 0{
            let parent = self.parent?.parent as! UITabBarController
            parent.selectedIndex = 0
            return
        }
        let storyBoard = UIStoryboard(name: "Today", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "AddFood") as AddFoodTodayViewController
        vc.viewModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            faButton.heightAnchor.constraint(equalToConstant: 50),
            faButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        faButton.layer.cornerRadius = 25
        faButton.layer.masksToBounds = true
        faButton.layer.borderWidth = 4
    }
    
    private lazy var titleStackView: TitleStackView = {
        let titleStackView = TitleStackView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44.0)))
        titleStackView.button.isHidden = true
        titleStackView.titleLabel.text = "TODAY"
        titleStackView.titleLabel.textColor = .white
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        return titleStackView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44.0)))
        tableHeaderView.addSubview(titleStackView)
        titleStackView.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 16.0).isActive = true
        titleStackView.topAnchor.constraint(equalTo: tableHeaderView.topAnchor).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: tableHeaderView.trailingAnchor, constant: -16.0).isActive = true
        titleStackView.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor).isActive = true
        return tableHeaderView
    }()
}

extension TodayViewController:UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let maxTitlePoint = tableView.convert(CGPoint(x: titleStackView.titleLabel.bounds.minX, y: titleStackView.titleLabel.bounds.maxY), from: titleStackView.titleLabel)
           title = scrollView.contentOffset.y > maxTitlePoint.y ? "TODAY" : nil
           if scrollView.contentOffset.y > maxTitlePoint.y{
               self.navigationController?.navigationBar.layoutIfNeeded()
           }
       }
}

extension TodayViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.foodsEatenToday.count == 0  && isLoading{
            tableView.setLoadingView()
        }else if viewModel.foodsEatenToday.count == 0  && !isLoading{
            tableView.setEmptyView(title: "Add what you've\neaten today")
        }
        else {
            tableView.restore()
        }
        return viewModel.foodsEatenToday.count + 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            viewModel.remove(index: indexPath.row-1)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let summaryPath = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [summaryPath], with: .automatic)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! TodaySummaryCell
            let calories = viewModel.todayCalories()
            cell.backgroundColor = UIColor.backgroundColor
            cell.caloriesToday = calories
            cell.percentageLabel.text = "\(calories)"
            cell.isLoading = isLoading
            cell.animate()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        let food = self.viewModel.foodsEatenToday[indexPath.row-1]
        cell.setUpCellWithFood(food)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return self.view.frame.size.height * 0.4
        }
        return 100
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
}
