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
        yAxis.labelTextColor = .systemGray3
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .systemGray3
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.animate(xAxisDuration: 0.5)
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        setData()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues, label: "Calories")
        set1.mode = .cubicBezier
        set1.circleRadius = 3
        set1.setCircleColor(UIColor(rgbColorCodeRed: 233, green: 116, blue: 124, alpha: 1))
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: UIColor(rgbColorCodeRed: 233, green: 116, blue: 124, alpha: 1))
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    let yValues:[ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 10),
        ChartDataEntry(x: 1, y: 5),
        ChartDataEntry(x: 2, y: 7),
        ChartDataEntry(x: 3, y: 5),
        ChartDataEntry(x: 4, y: 10),
        ChartDataEntry(x: 5, y: 6),
        ChartDataEntry(x: 6, y: 5),
    ]

}
