//
//  SearchViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/25.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift
class SearchViewController: UIViewController {
    var newsService = NewsService()
    var tableView = UITableView()
    var newsList = [News]()
    var images = [UIImage]()
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Search results..")
        ToastManager.shared.isQueueEnabled = true
        addTableView()
        createObservers()
        refreshNews(query: self.query)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        tableView.reloadData()
    }
    
    func refreshNews(query: String) {
        print("My query is: \(query)")
        newsService.getSearchPageNewsHelper(query: query)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.getNews(notification:)), name: Constants.searchNewsReady, object: nil)
        
    }
    
    @objc func getNews(notification: NSNotification) {
        newsList = newsService.getSearchPageNews()
        images = newsService.getCroppedImages()
        tableView.reloadData()
        SwiftSpinner.hide()
    }
    
   
    
   
    
    @objc func addTableView() {
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (newsList.count == 0) {
            self.tableView.setEmptyMessage(message: "No Search Results.")
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.restore()
        }
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let news = newsList[indexPath.section]
        let image = images[indexPath.section]
        //cell.set(news: news, self.view)
        cell.setForLargeImg(news: news, image: image, self.view)
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


extension UITableView {

    func setEmptyMessage(message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
