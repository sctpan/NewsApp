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
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkNewsCell", for: indexPath) as! BookmarkNewsCell
       cell.set(news: self.newsList[indexPath.item], parent: self)
       return cell
    }
}

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
