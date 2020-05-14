//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit
import BLTNBoard

class MyFoodViewController: UIViewController {
    let cellId = "FoodCell"
    var viewModel = MyFoodViewModel()
    let tableView = UITableView()
    var page = TextFieldBulletinPage(title: "New Food")
    
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = page // ... create your item here
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        tableView.allowsSelectionDuringEditing = true
        viewModel.fetchData {
            tableView.reloadData()
        }
        
        
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.pin(to:view)
        tableView.backgroundColor = .systemGray4
        tableView.separatorColor = .clear
        tableView.register(FoodCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = UIApplication.shared.keyWindow, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
        }
    }
    
    @objc func editSelector(_ sender:UIButton!){
        guard self.viewModel.foods.isEmpty  != true else { return }
        if(self.tableView.isEditing == true)
        {
            self.tableView.setEditing(false, animated: true)
            self.titleStackView.button.setTitle("Edit", for: .normal)
        }
        else
        {
            self.tableView.setEditing(true, animated: true)
            self.titleStackView.button.setTitle("Done", for: .normal)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            viewModel.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if viewModel.foods.count == 0{
                self.titleStackView.button.setTitle("Edit", for: .normal)
                tableView.setEditing(false, animated: true)
            }
        }
    }
    
    lazy var titleStackView: TitleStackView = {
        let titleStackView = TitleStackView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44.0)))
        titleStackView.button.addTarget(self, action: #selector(self.editSelector(_:)), for: .touchUpInside)
        titleStackView.titleLabel.text = "My Food"
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        return titleStackView
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44.0)))
        tableHeaderView.addSubview(titleStackView)
        titleStackView.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 16.0).isActive = true
        titleStackView.topAnchor.constraint(equalTo: tableHeaderView.topAnchor).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: tableHeaderView.trailingAnchor, constant: -16.0).isActive = true
        titleStackView.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor).isActive = true
        return tableHeaderView
    }()
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxTitlePoint = tableView.convert(CGPoint(x: titleStackView.titleLabel.bounds.minX, y: titleStackView.titleLabel.bounds.maxY), from: titleStackView.titleLabel)
        title = scrollView.contentOffset.y > maxTitlePoint.y ? "My Foods" : nil
    }
    
    private func setupView(){
        title = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemGray5
        navigationController?.navigationBar.shadowImage = UIImage()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView()
    }
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func fabTapped(_ button: UIButton) {
        
        page = TextFieldBulletinPage(title: "New Food")
        page.descriptionText = "Define a new food to track."
        page.actionButtonTitle = "Select Image"
        page.actionHandler = { item in
            print("Yeet")
        }
        page.image = UIImage(named: "fav_star")
        
        page.alternativeButtonTitle = "Not now"
        page.alternativeHandler = {
            item in
            self.bulletinManager.dismissBulletin()
        }
        bulletinManager = BLTNItemManager(rootItem: page)
        bulletinManager.showBulletin(above: self)

        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    button.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
        bulletinManager.popItem()
        
        
        
//        let storyBoard = UIStoryboard(name: "MyFood", bundle: nil)
//        let vc = storyBoard.instantiateViewController(identifier: "AddFood") as AddFoodViewController
//        vc.viewModel = self.viewModel
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupButton() {
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
    
}

extension MyFoodViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FoodCell
        let food = self.viewModel.foods[indexPath.row]
        cell.setUpCellWithFood(food)
        //        let caloriesString = String(food.calories)
        //        cell.foodTitleLabel.text = "\(food.name?.capitalized ?? "")"
        //        cell.calorieLabel.text = "\(caloriesString) cal"
        //        if let data = food.image{
        //            cell.foodImageView.image = UIImage(data: data)
        //        }
        //        cell.contentView.backgroundColor = UIColor.clear
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
}

extension MyFoodViewController:UITableViewDelegate{
}
