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
    
    lazy var lineChartView:LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white //.systemGray3
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(1, force: false)
        chartView.xAxis.labelTextColor = .white //.systemGray3
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelRotationAngle = -45
        chartView.animate(xAxisDuration: 0.5)
        chartView.backgroundColor = UIColor.backgroundColor
        
        return chartView
    }()
    let viewModel = TrendsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    func setData(){
        
        var referenceTimeInterval: TimeInterval = 0
        let data = viewModel.getProcessed7DayData()
        if let minTimeInterval = (data.map { $0.date.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        // Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        
        lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
        
        // Define chart entries
        var entries = [ChartDataEntry]()
        for object in data {
            let timeInterval = object.date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yValue = object.calories
            let entry = ChartDataEntry(x: xValue, y: Double(yValue))
            entries.append(entry)
        }
        let set1 = LineChartDataSet(entries: entries, label: "")
        set1.mode = .cubicBezier
        set1.circleRadius = 3
        set1.setCircleColor(UIColor(rgbColorCodeRed: 233, green: 116, blue: 124, alpha: 1))
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: UIColor(rgbColorCodeRed: 233, green: 116, blue: 124, alpha: 1))
        set1.fillAlpha = 0.7
        set1.drawFilledEnabled = true
        
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data2 = LineChartData(dataSet: set1)
        data2.setDrawValues(false)
        lineChartView.data = data2
    }
    
}

