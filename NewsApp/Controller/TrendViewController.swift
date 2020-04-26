//
//  TrendViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/18.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import Charts

class TrendViewController: UIViewController {
    var keyword = "Coronavirus"
    var searchLabel: UILabel!
    var searchField: UITextField!
    let borderColor: UIColor = UIColor( red: CGFloat(191/255.0), green: CGFloat(191/255.0), blue: CGFloat(191/255.0), alpha: CGFloat(1.0))
    let newsService = NewsService()
    var chartData: [Int]!
    var lineChart: LineChartView!
    override func viewDidLoad() {
        addSearchLabel()
        addSearchField()
        createObservers()
        addLineChart()
        newsService.getChartDataHelper(keyword: keyword)
        
    }
    
    func addLineChart() {
        lineChart = LineChartView()
        view.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 40).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        lineChart.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func addSearchLabel() {
        searchLabel = UILabel()
        searchLabel.text = "Enter Search Term"
        view.addSubview(searchLabel)
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    func addSearchField() {
        searchField = UITextField()
        searchField.layer.borderWidth = 1
        searchField.layer.cornerRadius = 5
        searchField.layer.borderColor = borderColor.cgColor
        searchField.placeholder = "Enter Search term.."
        searchField.font = UIFont.systemFont(ofSize: 14)
        searchField.frame.size.height = 36
        searchField.setLeftPadding(10)
        searchField.autocorrectionType = UITextAutocorrectionType.no
        searchField.returnKeyType = UIReturnKeyType.done
        searchField.autocapitalizationType = .none
        searchField.delegate = self
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(TrendViewController.updateChart(notification:)), name: Constants.chartDataReady, object: nil)
    }
    
    @objc func updateChart(notification: NSNotification) {
        chartData = newsService.getChartData()
        print(chartData.count)
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<chartData.count {
            let value = ChartDataEntry(x: Double(i), y: Double(chartData[i]))
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Trending Chart for \(keyword)")
        line1.colors = [NSUIColor.systemBlue]
        line1.drawCircleHoleEnabled = false
        line1.circleColors = [NSUIColor.systemBlue]
        line1.circleRadius = 5
        
        let data = LineChartData()
        data.addDataSet(line1)
        lineChart.data = data
        lineChart.notifyDataSetChanged()
    }
    
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension TrendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != nil {
            self.keyword = textField.text!
        }
        self.newsService.getChartDataHelper(keyword: self.keyword)
        return true
    }
}
