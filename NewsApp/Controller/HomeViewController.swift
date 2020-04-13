//
//  HomeViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let searchController = UISearchController()
    var weatherView: WeatherView!
    var weatherService = WeatherService()
    var weatherInfo: Weather!
    var tableView = UITableView()
    var newsList: [News] = [News]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
//        scrollView.contentSize.width = view.frame.size.width - 20
//        scrollView.contentSize.height = view.frame.size.height
        addSearchBar()
        
        addTableView()
        createObservers()
        
        
      //  addScrollView()
    }
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.getWeatherInfo(notification:)), name: Constants.weatherDataReady, object: nil)
    }
    
    @objc func getWeatherInfo(notification: NSNotification) {
        weatherInfo = weatherService.getWeather()
        self.weatherView = WeatherView(weatherInfo: weatherInfo)
        addWeatherView()
    }
//    func addScrollView() {
//        scrollView.backgroundColor = .green
//        view.addSubview(scrollView)
//        setScrollViewConstraints()
//    }
    
    func addWeatherView() {
        
        tableView.tableHeaderView = weatherView
    }
    
    
    
    
    
//    func setScrollViewConstraints() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//    }
    
    
    func addSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
        
    func fetchNews() {
        for index in 0...9 {
            newsList.append(News(title: "News \(index)"))
        }
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        tableView.sectionHeaderHeight = 0.01;
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return 20.0
        } else {
            return 5.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsList.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let news = newsList[indexPath.section]
        cell.set(news: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = .white
        return headerView
    }
    
}
