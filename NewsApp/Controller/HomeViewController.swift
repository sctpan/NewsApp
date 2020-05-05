//
//  HomeViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift

class HomeViewController: UIViewController {
    let searchResultController = SearchResultViewController()
    var searchController: UISearchController!
    var weatherView: WeatherView!
    var weatherService = WeatherService()
    var newsService = NewsService()
    var weatherInfo: Weather!
    var tableView = UITableView()
    var newsList = [News]()
    let refreshControl = UIRefreshControl()
    var weatherReady = false
    var newsReady = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        StoreService.clearAllNews()
        SwiftSpinner.show(Constants.loadingMessage)
        ToastManager.shared.isQueueEnabled = true
      //  navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        addSearchBar()
        addTableView()
        createObservers()
        refreshPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    @objc func refreshPage() {
        print("refreshing")
        weatherReady = false
        newsReady = false
        weatherService.getInfo()
        newsService.getHomePageNewsHelper()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.addWeatherView(notification:)), name: Constants.weatherDataReady, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.getNews(notification:)), name: Constants.homeNewsReady, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showSearchPage(notification:)), name: Constants.showSearchResultPageForHome, object: nil)
        
    }
    
    @objc func showSearchPage(notification: NSNotification) {
        let query = searchResultController.selectedQuery
        if let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as? SearchViewController {
            vc.query = query
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func getNews(notification: NSNotification) {
        newsList = newsService.getHomePageNews()
        tableView.reloadData()
        newsReady = true
        if(weatherReady) {
            refreshControl.endRefreshing()
            SwiftSpinner.hide()
        }
    }
    
    @objc func addWeatherView(notification: NSNotification) {
        weatherInfo = weatherService.getWeather()
        self.weatherView = WeatherView(weatherInfo: weatherInfo)
        tableView.tableHeaderView = weatherView
        weatherReady = true
        if(newsReady) {
            SwiftSpinner.hide()
            refreshControl.endRefreshing()
        }
    }
    
    
    func addSearchBar() {
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.placeholder = Constants.searchPlaceholder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = searchResultController
    }
    
    @objc func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
//        tableView.refreshControl = refreshControl
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
        print("newsList count: \(newsList.count)")
        return newsList.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let news = newsList[indexPath.section]
        cell.set(news: news, self.view)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = newsList[indexPath.section]
        if let vc = storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController {
            vc.news = selectedNews
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let news = self.newsList[indexPath.section]
        var bookmarkImage = UIImage(systemName: "bookmark")
        if StoreService.get(key: news.id) != nil {
            bookmarkImage = UIImage(systemName: "bookmark.fill")
        }
        let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) {
            action in
            ShareService.shareWithTwitter(url: news.shareUrl)
        }
        
        let bookmark = UIAction(title: "Bookmark", image: bookmarkImage) {
            action in
            let cell = tableView.cellForRow(at: indexPath) as! NewsCell
            cell.buttonClicked()
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Menu", children: [share, bookmark])
        }
    }
}
