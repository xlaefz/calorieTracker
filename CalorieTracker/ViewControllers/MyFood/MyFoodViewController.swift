//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class TitleStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        axis = .horizontal
        alignment = .center
        addArrangedSubview(titleLabel)
        addArrangedSubview(button)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .heavy)
        label.text = "My Foods"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let buttonWidth: CGFloat = 50
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: buttonWidth)))
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
}


class MyFoodViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellId = "FoodCell"
    var viewModel = MyFoodViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
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
        guard self.viewModel.foods?.isEmpty  != true else { return }
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.titleStackView.button.setTitle("Edit", for: .normal)
        }
        else
        {
            self.tableView.isEditing = true
            self.titleStackView.button.setTitle("Done", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let movedObjTemp = viewModel.foods?[sourceIndexPath.row] else { return }
        viewModel.foods?.remove(at: sourceIndexPath.row)
        viewModel.foods?.insert(movedObjTemp, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            viewModel.foods?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    lazy var titleStackView: TitleStackView = {
        let titleStackView = TitleStackView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44.0)))
        titleStackView.button.addTarget(self, action: #selector(self.editSelector(_:)), for: .touchUpInside)
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
        navigationController?.navigationBar.barTintColor = UIColor.white
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
        let storyBoard = UIStoryboard(name: "MyFood", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "AddFood") as AddFoodViewController
        vc.viewModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
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
        return viewModel.foods?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! RoundedTableViewCell
        guard let food = self.viewModel.foods?[indexPath.row] else { return UITableViewCell()}
        cell.foodLabel.text = food.name
        cell.calorieLabel.text = String(food.calories)
        cell.foodImageView.image = UIImage(data: food.image)
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
