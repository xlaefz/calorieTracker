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
    var isLoading = true
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = page // ... create your item here
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupView()
        tableView.allowsSelectionDuringEditing = true
        viewModel.fetchData { [weak self] in
            self?.isLoading = false
            self?.tableView.reloadData()
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
    
    func presentEditorWithFood(_ food:Food){
        page = TextFieldBulletinPage(title: "Edit Food")
        page.viewModel = self.viewModel
        page.delegate = self
        page.descriptionText = "Edit your current food"
        page.actionButtonTitle = "Save"
        page.foodNameTextField?.text = food.name
        page.caloriesTextField?.text = String(food.calories)
        page.pickedImage = UIImage(data: food.image!)
        page.actionHandler = {[weak self] item in
            guard let self = self else { return }
            guard let foodNameText = self.page.foodNameTextField.text, let _calories = self.page.caloriesTextField.text, !(self.page.foodNameTextField.text?.isEmpty ?? false), !(self.page.caloriesTextField.text?.isEmpty ?? false), let _image = self.page.pickedImage else { return }
            guard let data = _image.pngData() else { return }
            self.viewModel.editFood(food: food, name: foodNameText, calories: Int(_calories) ?? 0, data: data)
            self.bulletinManager.dismissBulletin()
            self.tableView.reloadData()
        }
        page.alternativeButtonTitle = "Not now"
        page.alternativeHandler = {
            item in
            self.bulletinManager.dismissBulletin()
        }
        bulletinManager = BLTNItemManager(rootItem: page)
        bulletinManager.showBulletin(above: self)
        page.foodNameTextField.text = food.name
        page.caloriesTextField.text = String(food.calories)
        page.selectedImage.image = UIImage(data: food.image!)
        
    }
    
    @objc func fabTapped(_ button: UIButton) {
        page = TextFieldBulletinPage(title: "New Food")
        page.viewModel = self.viewModel
        page.delegate = self
        page.descriptionText = "Define a new food to track."
        page.actionButtonTitle = "Save"
        page.actionHandler = {[weak self] item in
            guard let self = self else { return }
            guard let _food = self.page.foodNameTextField.text, let _calories = self.page.caloriesTextField.text, !(self.page.foodNameTextField.text?.isEmpty ?? false), !(self.page.caloriesTextField.text?.isEmpty ?? false), let _image = self.page.pickedImage else { return }
            guard let data = _image.pngData() else { return }
            self.viewModel.addFood(name: _food, calories: Int(_calories) ?? 0, data: data, completion:{ [weak self ] in
                self?.bulletinManager.dismissBulletin()
                self?.tableView.reloadData()
                }
            )
            
        }
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
        if viewModel.foods.count == 0  && isLoading{
            tableView.setLoadingView()
        }else if viewModel.foods.count == 0  && !isLoading{
            tableView.setEmptyView(title: "Add some foods to \nstart tracking!", message: "")
        }
        else {
            tableView.restore()
        }
        return viewModel.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FoodCell
        let food = self.viewModel.foods[indexPath.row]
        cell.setUpCellWithFood(food)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = viewModel.foods[indexPath.row]
        presentEditorWithFood(food)
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
