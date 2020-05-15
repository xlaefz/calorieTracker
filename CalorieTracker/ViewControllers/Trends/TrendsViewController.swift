//
//  TrendsViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class TrendsViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = TrendsViewModel()
    let cellId = "charts"
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.backgroundColor = .systemGray5
        tableView.separatorColor = .clear
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.tableView.contentInset = insets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData { [weak self] in
            self?.isLoading = false
            self?.tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    lazy var titleStackView: TitleStackView = {
        let titleStackView = TitleStackView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44.0)))
        titleStackView.titleLabel.text = "Trends"
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.button.isHidden = true
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
        title = scrollView.contentOffset.y > maxTitlePoint.y ? "Trends" : nil
    }
}

extension TrendsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = {
            let view = UIView(frame: CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: self.view.frame.size.width, height: 50))
            view.backgroundColor = .systemGray5
            let label = UILabel(frame: CGRect(x: 15, y: 15, width: 400, height: 30))
            label.textColor = UIColor.black
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
            label.textAlignment = .left
            label.text = viewModel.getSectionTitle(forSection: section)
            view.addSubview(label)
            return view
        }()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ChartTableViewCell
        let section = indexPath.section
        let chartData = viewModel.getProcessedData(forSection: section)
        cell.setData(data: chartData)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  400
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading{
                          tableView.setLoadingView()
              }
        else if viewModel.foodsEatenAllTime.count == 0  && viewModel.foodsEatenPast7Days.count == 0 && !isLoading{
            tableView.setEmptyView(title: "Add some foods to \nstart tracking!", message: "")
        }
        else {
            tableView.restore()
        }
        return viewModel.data.count
    }
    
    
}

