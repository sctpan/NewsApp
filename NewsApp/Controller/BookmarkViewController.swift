//
//  BookmarkViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/15.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    var newsList: [News]!
    let layout = CollectionLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    )
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        newsList = StoreService.getNewsList()
        addCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh() {
        newsList = StoreService.getNewsList()
        collectionView.reloadData()
    }
    
    func addCollectionView() {
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(BookmarkNewsCell.self, forCellWithReuseIdentifier: "BookmarkNewsCell")
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (newsList.count == 0) {
            self.collectionView.setEmptyMessage(message: "No bookmarks added.")
        } else {
            self.collectionView.restore()
        }
        return newsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkNewsCell", for: indexPath) as! BookmarkNewsCell
       cell.set(news: self.newsList[indexPath.item], parent: self)
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let news = self.newsList[indexPath.item]
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
            let cell = collectionView.cellForItem(at: indexPath) as! BookmarkNewsCell
            cell.buttonClicked()
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Menu", children: [share, bookmark])
        }
    }
    
}

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = newsList[indexPath.item]
        if let vc = storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController {
            vc.news = selectedNews
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UICollectionView {

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
