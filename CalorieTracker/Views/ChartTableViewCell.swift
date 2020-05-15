//
//  ChartTableViewCell.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/14/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(lineChartView)
        lineChartView.pin(to: self)
    }
    
    var data:[ChartPoint]!

    lazy var lineChartView:LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .systemGray3
        yAxis.axisLineColor = .systemGray5
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .systemGray3
        chartView.xAxis.axisLineColor = .systemGray5
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelRotationAngle = -45
        chartView.animate(xAxisDuration: 0.5)
        return chartView
    }()
    
    func setData(data:[ChartPoint]){
           var referenceTimeInterval: TimeInterval = 0
            self.data = data
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
           set1.setColor(.red)
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

extension ChartTableViewCell:ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
       }
}
