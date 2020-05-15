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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.backgroundColor = .systemGray5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
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
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
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
        return 2
    }
    
    
}

