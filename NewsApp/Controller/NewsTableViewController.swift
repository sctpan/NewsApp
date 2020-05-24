//
//  NewsTableViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/18.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftSpinner
import Toast_Swift
class NewsTableViewController: UIViewController {
    var itemTitle = ""
    var section: String!
    var newsList = [News]()
    var images = [UIImage]()
    let newsService = NewsService()
    var tableView = UITableView()
    let refreshControl = UIRefreshControl()
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.itemTitle = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        SwiftSpinner.show("Loading \(itemTitle) Headlines..")
       // ToastManager.shared.isQueueEnabled = true
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        section = Constants.sections[itemTitle]
        createObservers()
        refreshNews()
        addTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
       super.viewWillAppear(animated)
       if let selectedIndexPath = tableView.indexPathForSelectedRow {
           tableView.deselectRow(at: selectedIndexPath, animated: animated)
       }
       tableView.reloadData()
    }
    
     @objc func addTableView() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
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
       tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
       tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
       tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
       
    @objc func refreshNews() {
        newsService.getHeadlinesPageNewsHelper(section: self.section)
    }
    
    func createObservers() {
      NotificationCenter.default.addObserver(self, selector: #selector(NewsTableViewController.getNews(notification:)), name: Constants.headlinesNewsReady, object: nil)
    }
    
    @objc func getNews(notification: NSNotification) {
        newsList = newsService.getHeadlinesPageNews()
        images = newsService.getCroppedImages()
        tableView.reloadData()
        refreshControl.endRefreshing()
        SwiftSpinner.hide()
    }
    
}

extension NewsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
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
        let image = images[indexPath.section]
       // cell.set(news: news, self.view)
        cell.setForLargeImg(news: news, image: image, self.view)
        return cell
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 5))
        headerView.backgroundColor = .white
        return headerView
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = newsList[indexPath.section]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "detailViewController") as! DetailViewController
        vc.news = selectedNews
        navigationController?.pushViewController(vc, animated: true)
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

extension NewsTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.itemTitle)
    }
}
